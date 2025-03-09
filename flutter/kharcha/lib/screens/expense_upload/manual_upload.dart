import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ManualUploadScreen extends StatefulWidget {
  const ManualUploadScreen({super.key});

  @override
  _ManualUploadScreenState createState() => _ManualUploadScreenState();
}

class _ManualUploadScreenState extends State<ManualUploadScreen> {
  final GetStorage storage = GetStorage();
  String? _selectedCategory;
  bool _isIncome = false; // false for expense, true for income
  final TextEditingController _amountController = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {'name': 'Food', 'icon': Icons.fastfood},
    {'name': 'Shopping', 'icon': Icons.shopping_cart},
    {'name': 'Transportation', 'icon': Icons.directions_car},
    {'name': 'Housing', 'icon': Icons.home},
    {'name': 'Medical', 'icon': Icons.local_hospital},
    {'name': 'Others', 'icon': Icons.more_horiz},
  ];

  List<Map<String, dynamic>> expenses = [];
  List<Map<String, dynamic>> incomes = [];

  @override
  void initState() {
    super.initState();
    _loadStoredData();
  }

  void _loadStoredData() {
    expenses = List<Map<String, dynamic>>.from(storage.read('expenses') ?? []);
    incomes = List<Map<String, dynamic>>.from(storage.read('incomes') ?? []);
    setState(() {});
  }

  void _saveData() {
    storage.write('expenses', expenses);
    storage.write('incomes', incomes);
  }

  void _submitForm() {
    if (_selectedCategory == null || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category and enter an amount.'),
        ),
      );
      return;
    }

    double amount = double.tryParse(_amountController.text) ?? 0;
    String transactionType = _isIncome ? "Income" : "Expense";

    Map<String, dynamic> transaction = {
      'category': _selectedCategory,
      'amount': amount,
      'date': DateTime.now().toIso8601String(), // Ensuring unique timestamp
    };

    setState(() {
      if (_isIncome) {
        incomes = List.from(incomes)..add(transaction);
      } else {
        expenses = List.from(expenses)..add(transaction);
      }
    });

    _saveData();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$transactionType of ₹${amount.toStringAsFixed(2)} added in $_selectedCategory',
        ),
      ),
    );

    _amountController.clear();
    setState(() {
      _selectedCategory = null;
      _isIncome = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalExpense = expenses.fold(0, (sum, item) => sum + item['amount']);
    double totalIncome = incomes.fold(0, (sum, item) => sum + item['amount']);

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Category:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children:
                  categories.map((category) {
                    return ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(category['icon'], size: 20),
                          const SizedBox(width: 5),
                          Text(category['name']),
                        ],
                      ),
                      selected: _selectedCategory == category['name'],
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory =
                              selected ? category['name'] : null;
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Transaction Type:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Radio(
                  value: false,
                  groupValue: _isIncome,
                  onChanged: (value) {
                    setState(() {
                      _isIncome = value as bool;
                    });
                  },
                ),
                const Text('Expense'),
                Radio(
                  value: true,
                  groupValue: _isIncome,
                  onChanged: (value) {
                    setState(() {
                      _isIncome = value as bool;
                    });
                  },
                ),
                const Text('Income'),
              ],
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.currency_rupee),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Transaction'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Expense: ₹${totalExpense.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Text(
              'Total Income: ₹${totalIncome.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    'Recent Expenses:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...expenses.map(
                    (tx) => ListTile(
                      title: Text(tx['category']),
                      subtitle: Text('₹${tx['amount'].toStringAsFixed(2)}'),
                      trailing: const Icon(
                        Icons.arrow_downward,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Recent Incomes:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...incomes.map(
                    (tx) => ListTile(
                      title: Text(tx['category']),
                      subtitle: Text('₹${tx['amount'].toStringAsFixed(2)}'),
                      trailing: const Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
