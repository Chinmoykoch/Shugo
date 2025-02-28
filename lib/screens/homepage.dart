import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shugo/functions/fetchLocation.dart';
import 'package:shugo/widgets/mapmodal.dart';
import 'package:shugo/widgets/pointmap.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final locationController = Location();
  LatLng? currentPosition;
  final controller = Get.put(MapController());

  String? selectedEmergencyType;
  LatLng? selectedLocation;

  final List<String> _incidentTypes = [
    'Theft',
    'Assault',
    'Vandalism',
    'Missing Person',
    'Fraud',
    'Other'
  ];

  // void _showSOSForm(BuildContext context) {
  //   showModalBottomSheet(
  //     backgroundColor: Color(0XFF1A1A1A),
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Text(
  //               "SOS Details",
  //               style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white),
  //             ),
  //             const SizedBox(height: 20),
  //             DropdownButtonFormField<String>(
  //               value: selectedEmergencyType,
  //               decoration: InputDecoration(
  //                 labelText: "Emergency Type",
  //                 labelStyle: const TextStyle(color: Colors.white),
  //                 border: OutlineInputBorder(),
  //               ),
  //               dropdownColor: Colors.black,
  //               items: _incidentTypes.map((String type) {
  //                 return DropdownMenuItem<String>(
  //                   value: type,
  //                   child:
  //                       Text(type, style: const TextStyle(color: Colors.white)),
  //                 );
  //               }).toList(),
  //               onChanged: (String? newValue) {
  //                 setState(() {
  //                   selectedEmergencyType = newValue;
  //                 });
  //               },
  //             ),
  //             const SizedBox(height: 10),
  //             // GestureDetector(
  //             //   onTap: () async {
  //             //     LatLng? pickedLocation = await Navigator.push(
  //             //       context,
  //             //       MaterialPageRoute(builder: (context) => MapPickerScreen()),
  //             //     );
  //             //     if (pickedLocation != null) {
  //             //       setState(() {
  //             //         selectedLocation = pickedLocation;
  //             //       });
  //             //     }
  //             //   },
  //             //   child: AbsorbPointer(
  //             //     child: TextField(
  //             //       decoration: InputDecoration(
  //             //         labelText: selectedLocation == null
  //             //             ? "Pick Location on Map"
  //             //             : "Location: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}",
  //             //         labelStyle: const TextStyle(color: Colors.white),
  //             //         border: OutlineInputBorder(),
  //             //         suffixIcon:
  //             //             const Icon(LucideIcons.mapPin, color: Colors.white),
  //             //       ),
  //             //     ),
  //             //   ),
  //             // ),
  //             const SizedBox(height: 10),
  //             TextField(
  //               decoration: const InputDecoration(
  //                 labelText: "Additional Information",
  //                 border: OutlineInputBorder(),
  //               ),
  //               maxLines: 3,
  //             ),
  //             const SizedBox(height: 20),
  //             ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.red,
  //                 foregroundColor: Colors.white,
  //               ),
  //               child: const Text("Send SOS"),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // FloatingActionButton(
          //   backgroundColor: Colors.red,
          //   child: const Icon(Icons.sos, size: 36, color: Colors.white),
          //   onPressed: () => _showSOSForm(context),
          // ),
          const SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: Colors.red,
            child: const Icon(
              Icons.sos,
              color: Colors.white,
            ),
            onPressed: () {
              MaptypeModal(context);
            },
          ),
        ],
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class MapController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  static const LatLng _pGooglePlex = LatLng(26.142054, 91.660482);
  static const LatLng MountainView = LatLng(26.158117, 91.689965);
  final Rx<LatLng?> currentPosition = Rx<LatLng?>(null);

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    final locationService = Location();

    // Check if service is enabled
    bool serviceEnabled = await locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationService.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check for permission
    PermissionStatus permissionGranted = await locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get location
    LocationData locationData = await locationService.getLocation();
    currentPosition.value = LatLng(
        locationData.latitude ?? _pGooglePlex.latitude,
        locationData.longitude ?? _pGooglePlex.longitude);

    // Listen for location changes
    locationService.onLocationChanged.listen((newLocation) {
      if (newLocation.latitude != null && newLocation.longitude != null) {
        currentPosition.value =
            LatLng(newLocation.latitude!, newLocation.longitude!);
      }
    });
  }

  List<Widget> get screens => [
        Obx(() => currentPosition.value == null
            ? const Center(child: CircularProgressIndicator())
            : PointMap(
                currentPosition: currentPosition.value,
                pGooglePlex: _pGooglePlex,
                MountainView: MountainView,
              )),
        const Scaffold(body: Text("Report")),
      ];
}

class MapPickerScreen extends StatelessWidget {
  const MapPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick a Location")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, const LatLng(26.1445, 91.6782));
          },
          child: const Text("Pick this location"),
        ),
      ),
    );
  }
}
