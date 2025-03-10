import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kharcha/screens/home/widgets/all_upcoming_transaction.dart';

class UpcommingTransaction extends StatelessWidget {
  const UpcommingTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }
}

class UpcomingTransactionCards extends StatelessWidget {
  const UpcomingTransactionCards({
    super.key,
    required this.name,
    required this.amount,
    required this.date,
  });

  final String name;
  final String amount;
  final String date;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
              Text(name, style: TextStyle(fontSize: 16)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("₹", style: TextStyle(fontSize: 14)),
                  Text(amount.toString(), style: TextStyle(fontSize: 14)),
                  Text("/month", style: TextStyle(fontSize: 14)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Due ", style: TextStyle(fontSize: 14)),
                  Text(date, style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
