import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<String, List<FlSpot>> expenseData = {
    "Week": [
      FlSpot(1, 50),
      FlSpot(2, 40),
      FlSpot(3, 70),
      FlSpot(4, 60),
      FlSpot(5, 80),
      FlSpot(6, 100), // Peak
      FlSpot(7, 90),
    ],
    "Month": [
      FlSpot(1, 500),
      FlSpot(5, 700),
      FlSpot(10, 600),
      FlSpot(15, 800),
      FlSpot(20, 750),
      FlSpot(25, 900), // Peak
      FlSpot(30, 1000), // Peak
    ],
    "Year": [
      FlSpot(1, 3000),
      FlSpot(2, 2800),
      FlSpot(3, 4000),
      FlSpot(4, 4500),
      FlSpot(5, 4700),
      FlSpot(6, 5000),
      FlSpot(7, 5200),
      FlSpot(8, 5300),
      FlSpot(9, 5500),
      FlSpot(10, 6000), // Peak
      FlSpot(11, 6200), // Peak
      FlSpot(12, 6500), // Peak
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  List<FlSpot> getPeakPoints(List<FlSpot> spots) {
    double maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    return spots.where((spot) => spot.y == maxY).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Tracker"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: "Week"), Tab(text: "Month"), Tab(text: "Year")],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            ["Week", "Month", "Year"].map((selectedView) {
              List<FlSpot> spots = expenseData[selectedView]!;
              List<FlSpot> peakSpots = getPeakPoints(spots);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      "Debit Expenses",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 250, // Graph height reduced
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (selectedView == "Week") {
                                    return Text(
                                      [
                                        "Mon",
                                        "Tue",
                                        "Wed",
                                        "Thu",
                                        "Fri",
                                        "Sat",
                                        "Sun",
                                      ].elementAt(value.toInt() - 1),
                                    );
                                  } else if (selectedView == "Month") {
                                    return Text(value.toInt().toString());
                                  } else {
                                    return Text("M${value.toInt()}");
                                  }
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 4,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.2),
                              ),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, _, __, ___) {
                                  bool isPeak = peakSpots.contains(spot);
                                  return FlDotCirclePainter(
                                    radius: isPeak ? 6 : 4,
                                    color: isPeak ? Colors.red : Colors.blue,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "Credit Expenses",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 250, // Graph height reduced
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (selectedView == "Week") {
                                    return Text(
                                      [
                                        "Mon",
                                        "Tue",
                                        "Wed",
                                        "Thu",
                                        "Fri",
                                        "Sat",
                                        "Sun",
                                      ].elementAt(value.toInt() - 1),
                                    );
                                  } else if (selectedView == "Month") {
                                    return Text(value.toInt().toString());
                                  } else {
                                    return Text("M${value.toInt()}");
                                  }
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 4,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.2),
                              ),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, _, __, ___) {
                                  bool isPeak = peakSpots.contains(spot);
                                  return FlDotCirclePainter(
                                    radius: isPeak ? 6 : 4,
                                    color: isPeak ? Colors.red : Colors.blue,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}
