import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final double budget = 7000;
  final double expenses = 5000;

  @override
  Widget build(BuildContext context) {
    double remaining = budget - expenses;
    double percentage = (remaining / budget).clamp(0.0, 1.0);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        // title: Text(
        //   "Upcoming Transaction",
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontSize: 18,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: .6, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Montly Statistics",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 20),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "Income",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "0",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Expense",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "0",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Balance",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "0",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.6, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Monthly Budget Planner",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // Align items properly
                      children: [
                        CircularPercentIndicator(
                          radius: 50.0,
                          lineWidth: 8.0,
                          percent: percentage,
                          center: Text(
                            "${(percentage * 100).toInt()}%",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          progressColor:
                              percentage == 0 ? Colors.red : Colors.yellow,
                          backgroundColor: Colors.grey.shade800,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          // Ensures column takes available space
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildStatRow(
                                "Remaining:",
                                remaining,
                                remaining > 0 ? Colors.white : Colors.red,
                              ),
                              Divider(),
                              _buildStatRow("Budget:", budget, Colors.white),
                              const SizedBox(height: 10),
                              _buildStatRow(
                                "Expenses:",
                                expenses,
                                Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper function to create rows with flexible spacing
Widget _buildStatRow(String label, double value, Color valueColor) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
      Flexible(
        child: Text(
          "${value.toStringAsFixed(2)}",
          style: TextStyle(color: valueColor, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
