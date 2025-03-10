import 'package:flutter/material.dart';

class ExpenseTable extends StatelessWidget {
  final Map<String, dynamic> responseData;

  ExpenseTable({required this.responseData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Response Data")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns:
                responseData.keys.map((key) {
                  return DataColumn(label: Text(key));
                }).toList(),
            rows: [
              DataRow(
                cells:
                    responseData.values.map((value) {
                      return DataCell(Text(value.toString()));
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
