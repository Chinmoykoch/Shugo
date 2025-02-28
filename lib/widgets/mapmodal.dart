import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shugo/functions/fetchLocation.dart';
import 'package:shugo/screens/homepage.dart';

Future<dynamic> MaptypeModal(BuildContext context) {
  final controller = Get.put(MapController());

  // List of emergency types
  final List<String> emergencyTypes = [
    "Fire",
    "Accident",
    "Medical",
    "Sexual harrasment"
  ];

  // Form controllers
  final TextEditingController descriptionController = TextEditingController();
  final RxString selectedEmergency = "Fire".obs;
  final RxString coordinates = "Fetching location...".obs;

  // Fetch live coordinates with loading buffer
  Future<void> fetchLocation() async {
    coordinates.value = "Loading...";
    await Future.delayed(Duration(seconds: 2)); // Simulate loading time

    final locationController = Location();
    final serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      coordinates.value = "Location service disabled!";
      return;
    }

    final permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      coordinates.value = "Permission denied!";
      return;
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        coordinates.value =
            "${currentLocation.latitude}, ${currentLocation.longitude}";
        print("Successfully fetched location: ${coordinates.value}");
      }
    });
  }

  fetchLocation(); // Call when modal opens

  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Report Emergency",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20),

              // Emergency Type Dropdown
              Obx(() => DropdownButtonFormField<String>(
                    value: selectedEmergency.value,
                    items: emergencyTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child:
                            Text(type, style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) selectedEmergency.value = newValue;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: "Type of Emergency",
                    ),
                  )),
              SizedBox(height: 15),

              // Description Input
              TextField(
                controller: descriptionController,
                maxLines: 3,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: "Description (Optional)",
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              SizedBox(height: 15),

              // Live Coordinates with Loading Buffer
              Obx(() => Text(
                    "Live Location: ${coordinates.value}",
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  print("Emergency: ${selectedEmergency.value}");
                  print("Description: ${descriptionController.text}");
                  print("Location: ${coordinates.value}");
                  Get.back(); // Close modal
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Submit"),
              ),
            ],
          ),
        );
      });
}
