import 'package:flutter/material.dart';

class BudgetSummaryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> budgetList;

  const BudgetSummaryScreen({
    super.key,
    required this.budgetList,
    required responseData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Budget Summary",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(color: Colors.black),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Category',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Amount (₹)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows:
                      budgetList
                          .map(
                            (item) => DataRow(
                              cells: [
                                DataCell(Text(item["category"])),
                                DataCell(
                                  Text("₹${item["amount"].toStringAsFixed(2)}"),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Submit action: Save data to storage or backend
                Navigator.pop(context);
              },
              child: const Text(
                "Submit Budget",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
