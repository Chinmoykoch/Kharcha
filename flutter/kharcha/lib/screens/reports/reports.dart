import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kharcha/screens/reports/widgets/budget_planner.dart';
import 'package:kharcha/screens/reports/widgets/smart_budgeting.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final double budget = totalAmonut;
  final double expenses = 0;

  @override
  Widget build(BuildContext context) {
    double remaining = budget - expenses;
    double percentage = (remaining / budget).clamp(0.0, 1.0);
    return Scaffold(
      appBar: AppBar(leading: const BackButton(color: Colors.white)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              const MonthlyStatistics(),
              // const SizedBox(height: 30),
              // BudgetPlanner(
              //   percentage: percentage,
              //   remaining: remaining,
              //   budget: budget,
              //   expenses: expenses,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class MonthlyStatistics extends StatefulWidget {
  const MonthlyStatistics({super.key});

  @override
  _MonthlyStatisticsState createState() => _MonthlyStatisticsState();
}

class _MonthlyStatisticsState extends State<MonthlyStatistics> {
  String selectedMonth = "January"; // Default month

  final Map<String, Map<String, double>> monthlyData = {
    "January": {"Income": 0, "Expense": 0, "Savings": 2000},
    "February": {"Income": 20000, "Expense": 16000, "Savings": 4000},
    "March": {"Income": 25000, "Expense": 10000, "Balance": 15000},
  };

  @override
  Widget build(BuildContext context) {
    final data =
        monthlyData[selectedMonth] ?? {"Income": 0, "Expense": 0, "Balance": 0};

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.6, color: Colors.grey),
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
                      const Text(
                        "Monthly Statistics",
                        style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      DropdownButton<String>(
                        value: selectedMonth,
                        dropdownColor: Colors.grey[900], // Dark dropdown
                        style: const TextStyle(color: Colors.white),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMonth = newValue!;
                          });
                        },
                        items:
                            monthlyData.keys.map<DropdownMenuItem<String>>((
                              String month,
                            ) {
                              return DropdownMenuItem<String>(
                                value: month,
                                child: Text(
                                  month,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedMonth.substring(0, 3),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Column(
                        children: [
                          const Text(
                            "Income",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${data["Income"]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Expense",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${data["Expense"]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Balance",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${data["Balance"]}",
                            style: const TextStyle(
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
                        "Smart Budgeting",
                        style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => SmartBudgeting());
                        },
                        child: Icon(Icons.arrow_forward_ios, size: 30),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class BudgetPlanner extends StatelessWidget {
//   const BudgetPlanner({
//     super.key,
//     required this.percentage,
//     required this.remaining,
//     required this.budget,
//     required this.expenses,
//   });

//   final double percentage;
//   final double remaining;
//   final double budget;
//   final double expenses;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(width: 0.6, color: Colors.grey),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Monthly Budget Planner",
//                 style: TextStyle(
//                   color: Colors.yellow,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Get.to(() => BudgetPlannerScreen());
//                 },
//                 child: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 20,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             crossAxisAlignment:
//                 CrossAxisAlignment.center, // Align items properly
//             children: [
//               CircularPercentIndicator(
//                 radius: 50.0,
//                 lineWidth: 8.0,
//                 percent: percentage,
//                 center: Text(
//                   "${(percentage * 100).toInt()}%",
//                   style: TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//                 progressColor: percentage == 0 ? Colors.red : Colors.yellow,
//                 backgroundColor: Colors.grey.shade800,
//                 circularStrokeCap: CircularStrokeCap.round,
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 // Ensures column takes available space
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildStatRow(
//                       "Remaining:",
//                       remaining,
//                       remaining > 0 ? Colors.white : Colors.red,
//                     ),
//                     Divider(),
//                     _buildStatRow("Budget:", totalAmonut, Colors.white),
//                     const SizedBox(height: 10),
//                     _buildStatRow("Expenses:", expenses, Colors.white),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Helper function to create rows with flexible spacing
// Widget _buildStatRow(String label, double value, Color valueColor) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
//       Flexible(
//         child: Text(
//           "${value.toStringAsFixed(2)}",
//           style: TextStyle(color: valueColor, fontSize: 16),
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//     ],
//   );
// }
