import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false; // Flag for edit mode

  // Controllers to hold text values
  final TextEditingController balanceController = TextEditingController(
    text: '2200',
  );
  final TextEditingController incomeController = TextEditingController(
    text: '20000',
  );
  final TextEditingController savingsController = TextEditingController(
    text: '1000',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assests/images/profile.png'),
              ),
              const SizedBox(height: 15),

              // User Name
              Text(
                "Chinmoy",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),

              // Email
              const Text(
                "chinmoykoch10@gmail.com",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),

              const Text(
                "9101200132",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 20),

              // Editable Profile Info Cards
              ProfileInfoCard(
                icon: Icons.currency_rupee,
                title: 'Current Balance',
                controller: balanceController,
                isEditing: isEditing,
              ),

              const SizedBox(height: 20),

              ProfileInfoCard(
                icon: Icons.currency_rupee,
                title: 'Monthly Income',
                controller: incomeController,
                isEditing: isEditing,
              ),

              const SizedBox(height: 20),

              ProfileInfoCard(
                icon: Icons.currency_rupee,
                title: 'Monthly Saving Amount',
                controller: savingsController,
                isEditing: isEditing,
              ),

              const SizedBox(height: 30),

              // Edit & Save Button
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing; // Toggle editing mode
                  });
                },
                icon: Icon(isEditing ? Icons.check : Icons.edit),
                label: Text(isEditing ? 'Save' : 'Edit'),
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
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
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
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final TextEditingController controller;
  final bool isEditing;

  const ProfileInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.controller,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.8, color: Colors.grey.withOpacity(0.8)),
      ),
      child: ListTile(
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            if (isEditing)
              SizedBox(
                width: 80,
                height: 30,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 8,
                    ),
                  ),
                ),
              )
            else
              Text(
                controller.text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
