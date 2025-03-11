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
  List<Map<String, dynamic>> leaderboard = [];

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  void _loadPoints() {
    setState(() {
      globalPoints = storage.read('points') ?? 0;
      leaderboard = [
        {'name': 'Shayan', 'points': 90},
        {'name': 'Chinmoy', 'points': 36},
        {'name': 'You', 'points': globalPoints},
        {'name': 'TestUser', 'points': 9},
      ]..sort(
        (a, b) => b['points'].compareTo(a['points']),
      ); // Sort by points descending
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF121212,
      ), // Dark background for modern feel
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 36),
            const SizedBox(width: 10),
            Text(
              "Leaderboard",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,

        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // Trophy Icon or Header Decoration
            // Container(
            //   margin: const EdgeInsets.only(bottom: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [

            //       Text(
            //         "Top Performers",
            //         style: TextStyle(
            //           fontSize: 28,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white.withOpacity(0.9),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Leaderboard List
            Expanded(
              child: ListView.builder(
                itemCount: leaderboard.length,
                itemBuilder: (context, index) {
                  final isUser = leaderboard[index]['name'] == 'You';
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            isUser
                                ? [
                                  Colors.yellowAccent.shade700,
                                  Colors.yellowAccent.shade400,
                                ]
                                : [Colors.grey.shade900, Colors.grey.shade800],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Rank with Medal Icon for Top 3
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                index == 0
                                    ? Colors.amber
                                    : index == 1
                                    ? Colors.grey.shade400
                                    : index == 2
                                    ? Colors.yellow.shade700
                                    : Colors.grey.shade700,
                          ),
                          child: Center(
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Name
                        Expanded(
                          child: Text(
                            leaderboard[index]['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color:
                                  isUser
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                        // Points with Badge Style
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isUser
                                    ? Colors.black.withOpacity(0.8)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  isUser
                                      ? Colors.amber.shade200
                                      : Colors.grey.shade600,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            "${leaderboard[index]['points']} pts",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  isUser
                                      ? Colors.amber.shade100
                                      : Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Back to Home Button
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 20.0),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const NavigationScreen(),
            //         ),
            //       );
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.amber,
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 40,
            //         vertical: 16,
            //       ),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       elevation: 5,
            //     ),
            //     child: const Text(
            //       "Back to Home",
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
