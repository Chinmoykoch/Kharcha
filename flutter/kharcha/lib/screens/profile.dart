import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/profile.jpg',
              ), // Change this with your image
            ),
            const SizedBox(height: 15),

            // User Name
            Text(
              "Upcoming Transaction",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            // Email
            Text(
              "Upcoming Transaction",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 20),

            // Total Expenses
            ProfileInfoCard(
              icon: Icons.attach_money,
              title: 'Total Expenses',
              value: '\$1250',
            ),

            const SizedBox(height: 10),

            // Budget Limit
            ProfileInfoCard(
              icon: Icons.account_balance_wallet,
              title: 'Budget Limit',
              value: '\$2000',
            ),

            const SizedBox(height: 30),

            // Edit Profile Button
            ElevatedButton.icon(
              onPressed: () {
                Get.snackbar(
                  "Edit Profile",
                  "Feature coming soon!",
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 30,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Logout Button
            OutlinedButton.icon(
              onPressed: () {
                Get.defaultDialog(
                  title: "Logout",
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle logout action
                        Get.offAllNamed('/login'); // Navigate to login page
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Logout', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 30,
                ),
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable card for profile info
class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
