import 'package:flutter/material.dart';
import 'package:kharcha/screens/home/widgets/transactioncards.dart';

class TransactionListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transactionsList = [
    {
      "merchantName": "Amazon",
      "date": "2024-03-10",
      "amount": 1200,
      "type": "debit",
    },
    {
      "merchantName": "Salary",
      "date": "2024-03-05",
      "amount": 50000,
      "type": "credit",
    },
    {
      "merchantName": "Grocery Store",
      "date": "2024-03-12",
      "amount": 3000,
      "type": "debit",
    },
    {
      "merchantName": "Freelance Work",
      "date": "2024-03-15",
      "amount": 15000,
      "type": "credit",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaction List")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child:
            transactionsList.isEmpty
                ? const Center(child: Text("No transactions available"))
                : ListView.builder(
                  itemCount: transactionsList.length,
                  itemBuilder: (context, index) {
                    final transaction = transactionsList[index];
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
                  },
                ),
      ),
    );
  }
}
