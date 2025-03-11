import 'package:flutter/material.dart';
import 'package:kharcha/navigation.dart';

class BudgetSummaryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> budgetList;
  final List<Map<String, dynamic>> responseData;

  const BudgetSummaryScreen({
    super.key,
    required this.budgetList,
    required this.responseData,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayData =
        budgetList.isNotEmpty
            ? budgetList
            : List<Map<String, dynamic>>.from(responseData);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expenses Summary",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: BackButton(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.yellowAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      border: TableBorder.all(color: Colors.black),
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.yellowAccent,
                      ),
                      columns: const [
                        DataColumn(
                          label: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Category',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Amount (₹)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          numeric: true,
                        ),
                      ],
                      rows:
                          displayData.asMap().entries.map((entry) {
                            return DataRow(
                              color: MaterialStateColor.resolveWith(
                                (states) =>
                                    entry.key % 2 == 0
                                        ? Colors.grey.shade100
                                        : Colors.white,
                              ),
                              cells: [
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      entry.value["category"].toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      "₹${entry.value["amount"].toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellowAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavigationScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Submit Expenses",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
