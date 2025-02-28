import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

Future<String> getAddressFromLatLng(double latitude, double longitude) async {
  try {
    List<geo.Placemark> placemarks =
        await geo.placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      geo.Placemark place = placemarks.first;
      return "${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    }
    return "Address not found";
  } catch (e) {
    return "Failed to get address: $e";
  }
}

Future<void> _submitForm(
    String emergencyType,
    String description,
    String latitude,
    String longitude,
    String address,
    BuildContext context) async {
  final url = Uri.parse(
      'https://9880-2409-40e6-20b-513f-8880-19f4-1121-9b25.ngrok-free.app/api/reports');

  String? token = await getToken(); // Ensure token is awaited

  if (token == null || token.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Authentication required! Please login again.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  Map<String, dynamic> body = {
    'type': "sos",
    'name': emergencyType,
    'description': description,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'city': "",
    'country': ""
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Use Token from SharedPreferences
      },
      body: json.encode(body),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SOS Report Submitted Successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseData['message'] ?? 'Error occurred'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request failed: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<void> MaptypeModal(BuildContext context) async {
  final TextEditingController descriptionController = TextEditingController();
  final RxString selectedEmergency = "Fire".obs;
  final RxString coordinates = "Fetching location...".obs;
  final RxString cityState = "Fetching address...".obs;

  Future<void> fetchLocation() async {
    coordinates.value = "Loading...";
    cityState.value = "Fetching address...";

    Location locationController = Location();

    bool serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        coordinates.value = "Location service disabled!";
        return;
      }
    }

    PermissionStatus permission = await locationController.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await locationController.requestPermission();
      if (permission == PermissionStatus.denied) {
        coordinates.value = "Permission denied!";
        return;
      }
    }

    LocationData? currentLocation = await locationController.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      double lat = currentLocation.latitude!;
      double lng = currentLocation.longitude!;
      coordinates.value = "$lat, $lng";

      String address = await getAddressFromLatLng(lat, lng);
      cityState.value = address;
    }
  }

  await fetchLocation();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (builder) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Report Emergency",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Obx(() => DropdownButtonFormField<String>(
                  value: selectedEmergency.value,
                  items: ["Fire", "Accident", "Medical", "Sexual Harassment"]
                      .map((String type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) selectedEmergency.value = newValue;
                  },
                  decoration: const InputDecoration(
                    labelText: "Type of Emergency",
                  ),
                )),
            const SizedBox(height: 15),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description (Optional)",
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => Text("Address: ${cityState.value}",
                style: const TextStyle(color: Colors.white))),
            ElevatedButton(
              onPressed: () {
                List<String> latLng = coordinates.value.split(", ");
                String latitude = latLng[0];
                String longitude = latLng[1];

                _submitForm(selectedEmergency.value, descriptionController.text,
                    latitude, longitude, cityState.value, context);

                Get.back();
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      );
    },
  );
}
