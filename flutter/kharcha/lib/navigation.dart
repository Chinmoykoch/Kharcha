import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:kharcha/screens/analytics/analytics.dart';
import 'package:kharcha/screens/expense_upload/auto_upload.dart';
import 'package:kharcha/screens/expense_upload/manual_upload.dart';
import 'package:kharcha/screens/home/homepage.dart';
import 'package:kharcha/screens/profile/profile.dart';
import 'package:kharcha/screens/reports/reports.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      floatingActionButton: Obx(() {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Additional buttons when showOptions is true
            if (controller.showOptions.value)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          Get.to(() => ManualUploadScreen());
                        },
                        backgroundColor: Colors.white,
                        mini: true,
                        child: const Icon(Icons.edit, color: Colors.black),
                      ),

                      const SizedBox(width: 50),
                      FloatingActionButton(
                        onPressed: () {
                          Get.to(() => AutoUploadScreen());
                        },
                        backgroundColor: Colors.white,
                        mini: true,
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            FloatingActionButton(
              onPressed: () {
                controller.toggleOptions();
              },
              backgroundColor: const Color(0XFF141414),
              shape: const CircleBorder(),
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            ),
          ],
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10.0,
          color: const Color(0XFF141414),
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                NavItem(
                  icon: FontAwesomeIcons.house,
                  label: 'Home',
                  isSelected: controller.selectedIndex.value == 0,
                  onTap: () => controller.selectedIndex.value = 0,
                ),
                NavItem(
                  icon: FontAwesomeIcons.trophy,
                  label: 'LeaderBoard',
                  isSelected: controller.selectedIndex.value == 1,
                  onTap: () => controller.selectedIndex.value = 1,
                ),
                const SizedBox(width: 40),
                NavItem(
                  icon: LucideIcons.clipboard_list,
                  label: 'Reports',
                  isSelected: controller.selectedIndex.value == 2,
                  onTap: () => controller.selectedIndex.value = 2,
                ),
                NavItem(
                  icon: LucideIcons.user,
                  label: 'Profile',
                  isSelected: controller.selectedIndex.value == 3,
                  onTap: () => controller.selectedIndex.value = 3,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final RxBool showOptions = false.obs;

  final screens = [
    HomepageScreen(),
    LeaderboardScreen(),
    ReportsScreen(),
    const ProfileScreen(),
  ];

  void toggleOptions() {
    showOptions.value = !showOptions.value;
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white70,
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
