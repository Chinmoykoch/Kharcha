import 'package:flutter/material.dart';

class AllRecentTransactionScreen extends StatelessWidget {
  const AllRecentTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: Text(
          "Recent Transaction",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 20),
              Text(
                "Yesterday",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
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
