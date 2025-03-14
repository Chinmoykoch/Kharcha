import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kharcha/api.dart';
import 'package:kharcha/screens/home/widgets/all_recent_transaction.dart';
import 'package:kharcha/screens/home/widgets/quiz.dart';
import 'package:kharcha/screens/home/widgets/transactioncards.dart';
import 'package:kharcha/screens/home/widgets/upcomingtransaction.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:convert';

class HomepageScreen extends StatefulWidget {
  HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  String selectedOption = "Month";
  String username = "User";
  double balance = 0;
  int amount = 0;
  String date = "10/3/2025";
  String marchantName = "user";
  String status = 'completed';
  String category = '';
  List<dynamic> transactionsList = [];
  List<dynamic> utransactionsList = [];

  Map<String, double> monthlyData = {};

  // final Map<String, double> monthlyData = {
  //   "Grocery": 10,
  //   "Leisure": 5,
  //   "Bills": 8,
  //   "Medical": 4,
  //   "Others": 3,
  // };

  final Map<String, double> weeklyData = {
    "Grocery": 10,
    "Leisure": 5,
    "Bills": 8,
    "Medical": 4,
    "Others": 3,
  };

  final List<Color> colorList = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  Map<String, double> get dataMap {
    return selectedOption == "Month" ? monthlyData : weeklyData;
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Load data initially
    _quizes = 0;
    score = _storage.read("score") ?? 0;
    hasPlayedQuiz = _storage.read("hasPlayedQuiz") ?? false;
  }

  late int _quizes;
  final int _maxQuizes = 1;
  final GetStorage _storage = GetStorage();
  late int score;
  bool hasPlayedQuiz = false;

  void _startQuiz() {
    if (hasPlayedQuiz) {
      // Prevent playing quiz more than once while logged in
      return;
    }

    Get.to(() => QuizScreen())?.then((value) {
      setState(() {
        hasPlayedQuiz = true;
        _storage.write("hasPlayedQuiz", true);
      });
    });
  }

  Future<void> fetchData() async {
    await Api().fetchBalance();
    getBalance();
    getCompletedTransaction();
    getUpcomingTransaction();
    getBudget();
  }

  Future<void> _refreshData() async {
    await fetchData(); // Reload data
  }

  void getBalance() async {
    var balanceData = await Api().fetchBalance();
    if (balanceData != null && balanceData["user"] != null) {
      setState(() {
        username = balanceData["user"]["name"];
        balance =
            (balanceData["user"]["currentBalance"] as num)
                .toDouble(); // Corrected interpolation
      });
    } else {
      print("Error: balanceData or user data is null");
    }
  }

  void getBudget() async {
    var budgetData = await Api().budget();

    if (budgetData != null && budgetData['budgetPlan'] != null) {
      try {
        var budget = budgetData['budgetPlan'];

        // Ensure budget is a map and not a string
        Map<String, dynamic> finalBudget =
            (budget is String) ? jsonDecode(budget) : budget;

        // Convert values to double
        Map<String, double> dataMap = finalBudget.map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        );

        // Update state with valid data
        setState(() {
          monthlyData =
              dataMap.isNotEmpty
                  ? dataMap
                  : {
                    "Grocery": 300.0,
                    "Leisure": 200.0,
                    "Bills": 200.0,
                    "Medical": 100.0,
                    "Others": 600.0,
                  };
        });
      } catch (e) {
        print("Error parsing budget data: $e");
      }
    } else {}
  }

  void getCompletedTransaction() async {
    var balanceData = await Api().fetchBalance();

    if (balanceData != null && balanceData["transactions"] != null) {
      List<dynamic> allTransactions = balanceData["transactions"];

      // Filtering only completed transactions
      List<dynamic> completedTransactions =
          allTransactions
              .where((transaction) => transaction["status"] == "completed")
              .toList();

      setState(() {
        transactionsList = completedTransactions;
      });
    } else {
      print("Error: balanceData or transactions are null");
    }
  }

  void getUpcomingTransaction() async {
    var balanceData = await Api().fetchBalance();

    if (balanceData != null && balanceData["transactions"] != null) {
      List<dynamic> allTransactions = balanceData["transactions"];

      // Filtering only completed transactions
      List<dynamic> upcommingTransactions =
          allTransactions
              .where((transaction) => transaction["status"] == "upcomming")
              .toList();
      print(upcommingTransactions);
      setState(() {
        utransactionsList = upcommingTransactions;
      });
    } else {
      print("Error: balanceData or transactions are null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Hi, $username",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey,
                      //         borderRadius: BorderRadius.circular(30),
                      //       ),
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Icon(Icons.search),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 10),
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey,
                      //         borderRadius: BorderRadius.circular(30),
                      //       ),
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Icon(Icons.notifications),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Current Balance",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "₹$balance",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            DropdownButton<String>(
                              value: selectedOption,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedOption = newValue!;
                                });
                              },
                              items:
                                  [
                                    "Month",
                                    "Week",
                                  ].map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        dataMap.isEmpty
                            ? Center(
                              child: Text(
                                "Loading...",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                            : PieChart(
                              dataMap: dataMap,
                              chartType: ChartType.ring,
                              baseChartColor: Colors.grey[300]!,
                              colorList: colorList,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 2.5,
                              ringStrokeWidth: 32,
                              chartValuesOptions: ChartValuesOptions(
                                showChartValues: true,
                                showChartValuesOutside: true,
                                decimalPlaces: 0,
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Get.to(() => QuizScreen());
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              71,
                              71,
                              71,
                            ).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.support_agent,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Consult Personalized\nAssistant",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: hasPlayedQuiz ? null : _startQuiz,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color:
                                hasPlayedQuiz
                                    ? Colors
                                        .grey // Disabled state
                                    : const Color.fromARGB(
                                      255,
                                      71,
                                      71,
                                      71,
                                    ).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.support_agent,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  hasPlayedQuiz
                                      ? "You've already played the quiz"
                                      : "Know about your financial\nstatus",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                UpcommingTransaction(),
                const SizedBox(height: 10),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                        utransactionsList.map((transaction) {
                          return UpcomingTransactionCards(
                            name: transaction["merchantName"] ?? "Unknown",
                            date: transaction["time"] ?? "N/A",
                            amount: transaction["amount"]?.toString() ?? "0",
                          );
                        }).toList(),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Transaction",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Get.to(() => TransactionListScreen());
                    //   },
                    //   child: Text(
                    //     "See All",
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w300,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 10),

                Column(
                  children:
                      transactionsList.map((transaction) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: TransactionCard(
                            name: transaction["merchantName"] ?? "Unknown",
                            date: transaction["date"] ?? "N/A",
                            sign: transaction["type"] == "credit" ? "+" : "-",
                            amount: transaction["amount"]?.toString() ?? "0",
                            type: transaction["type"] ?? "debit",
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaidScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Paid Transactions")),
      body: Center(child: Text("Transaction Marked as Paid!")),
    );
  }
}
