import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kharcha/screens/home/widgets/all_recent_transaction.dart';
import 'package:kharcha/screens/home/widgets/all_upcoming_transaction.dart';
import 'package:pie_chart/pie_chart.dart';

class HomepageScreen extends StatefulWidget {
  HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  String selectedOption = "Month";

  final Map<String, double> monthlyData = {
    "Food": 30,
    "Transport": 25,
    "Shopping": 20,
    "Entertainment": 15,
    "Others": 10,
  };

  final Map<String, double> weeklyData = {
    "Food": 10,
    "Transport": 5,
    "Shopping": 8,
    "Entertainment": 4,
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                          "Hi, ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Chinmoy",
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
                                "₹15000",
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
                                ["Month", "Week"].map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    );
                                  },
                                ).toList(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upcoming Transaction",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => AllUpcomingTransactionScreen());
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

              SizedBox(
                height: 100,
                child: ListView.separated(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder:
                      (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    return UpcomingTransactionCards(
                      company: "Netflix",
                      price: "199",
                      days: "2",
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Transaction",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
              TransactionCards(
                name: "ganguly",
                date: "21/05/2025",
                sign: "+",
                amount: "150",
              ),
              const SizedBox(height: 8),
              TransactionCards(
                name: "J.S Stall",
                date: "21/05/2025",
                sign: "-",
                amount: "150",
              ),
              const SizedBox(height: 8),
              TransactionCards(
                name: "J.S Stall",
                date: "21/05/2025",
                sign: "-",
                amount: "150",
              ),
              const SizedBox(height: 8),
              TransactionCards(
                name: "J.S Stall",
                date: "21/05/2025",
                sign: "+",
                amount: "350",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpcomingTransactionCards extends StatelessWidget {
  const UpcomingTransactionCards({
    super.key,
    required this.company,
    required this.price,
    required this.days,
  });

  final String company;
  final String price;
  final String days;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(company, style: TextStyle(fontSize: 16)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("₹", style: TextStyle(fontSize: 14)),
                Text(price, style: TextStyle(fontSize: 14)),
                Text("/month", style: TextStyle(fontSize: 14)),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(days, style: TextStyle(fontSize: 14)),
                Text(" days left", style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionCards extends StatelessWidget {
  const TransactionCards({
    super.key,
    required this.name,
    required this.date,
    required this.sign,
    required this.amount,
  });

  final String name, date, sign, amount;

  @override
  Widget build(BuildContext context) {
    final Color amountColor = sign == "+" ? Colors.green : Colors.red;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  date,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  sign,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: amountColor,
                  ),
                ),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: amountColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
