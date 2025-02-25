import 'package:location/location.dart';
import 'package:get/get.dart';
import 'package:shugo/screens/homepage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> fetchLocationUpdates() async {
  final locationController = Location();
  LatLng? currentPosition;
  bool serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  final mapController = Get.find<MapController>();

  serviceEnabled = await locationController.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await locationController.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await locationController.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await locationController.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  locationController.onLocationChanged.listen((currentLocation) {
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      mapController.currentPosition.value =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      print(
          "This is current location: LatLng(${currentPosition!.latitude}, ${currentPosition!.longitude})");
    }
  });
}
