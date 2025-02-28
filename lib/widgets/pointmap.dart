import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PointMap extends StatefulWidget {
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
  State<PointMap> createState() => _PointMapState();
}

class _PointMapState extends State<PointMap> {
  Set<Circle> circles = {};

  @override
  void initState() {
    super.initState();
    _generateHeatmapCircles();
  }

  void _generateHeatmapCircles() {
    Set<Circle> createSmoothHeatmapEffect(LatLng center, Color color) {
      final Set<Circle> circles = {};
      const int circleCount = 30;
      final double maxRadius = 420;
      final double minRadius = 30;
      final double radiusStep = (maxRadius - minRadius) / (circleCount - 1);

      for (int i = 0; i < circleCount; i++) {
        final double radius = maxRadius - (radiusStep * i);
        final double opacity = 0.05 + (0.1 * i / (circleCount - 1));

        circles.add(
          Circle(
            circleId: CircleId("${center.latitude}_${center.longitude}_$i"),
            center: center,
            radius: radius,
            strokeWidth: 0,
            fillColor: color.withOpacity(opacity),
          ),
        );
      }

      return circles;
    }

    setState(() {
      circles = {
        // ...createSmoothHeatmapEffect(widget.currentPosition!, Colors.red),
        ...createSmoothHeatmapEffect(widget.MountainView, Colors.orange),
        ...createSmoothHeatmapEffect(widget._pGooglePlex, Colors.red),
      };
    });
  }

  void _onMapTapped(LatLng tappedPoint) {
    for (Circle circle in circles) {
      if (_isPointInsideCircle(tappedPoint, circle)) {
        _showBottomSheet(circle.center);
        break;
      }
    }
  }

  bool _isPointInsideCircle(LatLng tap, Circle circle) {
    double distance = _calculateDistance(
      tap.latitude,
      tap.longitude,
      circle.center.latitude,
      circle.center.longitude,
    );
    return distance <= circle.radius;
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371000; // Earth's radius in meters
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  void _showBottomSheet(LatLng center) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 500,
          width: double.infinity,
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Circle Tapped",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Latitude: ${center.latitude}"),
              Text("Longitude: ${center.longitude}"),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition:
          CameraPosition(target: widget.currentPosition!, zoom: 13),
      myLocationButtonEnabled: true,
      mapToolbarEnabled: true,
      zoomControlsEnabled: false,
      onTap: _onMapTapped,
      circles: circles,
    );
  }
}
