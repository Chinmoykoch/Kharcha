import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kharcha/api.dart';
import 'package:kharcha/screens/home/widgets/all_recent_transaction.dart';
import 'package:kharcha/screens/home/widgets/all_upcoming_transaction.dart';
import 'package:kharcha/screens/home/widgets/transactioncards.dart';
import 'package:kharcha/screens/home/widgets/upcomingtransaction.dart';
import 'package:pie_chart/pie_chart.dart';

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

  final Map<String, double> monthlyData = {
    "Grocery": 30,
    "Leisure": 25,
    "Bills": 20,
    "Medical": 15,
    "Others": 10,
  };

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
    Api().fetchBalance();
    getBalance();
    getCompletedTransaction();
    getUpcomingTransaction();
    // Call API when screen loads
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulating data fetch
    await Api().fetchBalance();
    getBalance();
    getCompletedTransaction();

    setState(() {}); // Ensure the UI updates after data is fetched
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
        onRefresh: _refreshData, // Function to refresh data
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
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.search),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.notifications),
                            ),
                          ),
                        ],
                      ),
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
                        PieChart(
                          dataMap: dataMap,
                          chartType: ChartType.ring,
                          baseChartColor: Colors.grey[300]!,
                          colorList: colorList,
                          chartRadius: MediaQuery.of(context).size.width / 2.5,
                          ringStrokeWidth: 32,
                          chartValuesOptions: ChartValuesOptions(
                            showChartValuesInPercentage: true,
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
                UpcommingTransaction(),
                const SizedBox(height: 10),

                SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Allows horizontal scrolling
                  child: Row(
                    children:
                        utransactionsList.map((transaction) {
                          return UpcomingTransactionCards(
                            name: transaction["merchantName"] ?? "Unknown",
                            date: transaction["date"] ?? "N/A",
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
                    GestureDetector(
                      onTap: () {
                        Get.to(() => AllRecentTransactionScreen());
                      },
                      child: Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
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
