import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shugo/screens/report_screen.dart';
import 'package:shugo/screens/homepage.dart';
import 'package:shugo/screens/profile.dart';
import 'package:shugo/screens/alert_screen.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 75,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: Colors.black,
          indicatorColor: Colors.green,
          destinations: const [
            NavigationDestination(
              icon: Icon(
                LucideIcons.house,
              ),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.file),
              label: 'Report',
            ),
            NavigationDestination(icon: Icon(LucideIcons.bell), label: 'Alert'),
            NavigationDestination(
                icon: Icon(LucideIcons.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const Homepage(),
    const ReportScreen(),
    const AlertScreen(),
    const ProfileScreen(),
  ];
}
