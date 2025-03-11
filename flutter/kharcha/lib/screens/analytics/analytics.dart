import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kharcha/navigation.dart';

final GetStorage storage = GetStorage();

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int globalPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  void _loadPoints() {
    setState(() {
      globalPoints = storage.read('points') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Leaderboard"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Your Score:",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "$globalPoints Points",
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.yellowAccent,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NavigationScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
              child: const Text(
                "Back to Home",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
