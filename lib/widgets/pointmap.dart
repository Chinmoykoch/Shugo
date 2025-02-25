import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PointMap extends StatelessWidget {
  const PointMap({
    super.key,
    required this.currentPosition,
    required LatLng pGooglePlex,
    required this.MountainView,
  }) : _pGooglePlex = pGooglePlex;

  final LatLng? currentPosition;
  final LatLng _pGooglePlex;
  final LatLng MountainView;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: currentPosition!, zoom: 13),
      myLocationButtonEnabled: true,
      mapToolbarEnabled: true,
      zoomControlsEnabled: false,
      markers: {
        Marker(
            markerId: MarkerId('currentPosition'),
            icon: BitmapDescriptor.defaultMarker,
            position: currentPosition!),
        Marker(
            markerId: MarkerId('sourceLocation'),
            icon: BitmapDescriptor.defaultMarker,
            position: _pGooglePlex),
        Marker(
            markerId: MarkerId('MLocation'),
            icon: BitmapDescriptor.defaultMarker,
            position: MountainView),
      },
    );
  }
}
