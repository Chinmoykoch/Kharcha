import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kharcha/screens/expense_upload/expense_table.dart';

double totalAmonut = 0;

class ManualUploadScreen extends StatefulWidget {
  const ManualUploadScreen({super.key});

  @override
  State<ManualUploadScreen> createState() => _BudgetPlannerScreenState();
}

class _BudgetPlannerScreenState extends State<ManualUploadScreen> {
  final List<Map<String, dynamic>> _budgetList = [];
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = [
    "Bills",
    "Grocery",
    "Leisure",
    "Medical",
    "Others",
  ];

  final _Budget = GetStorage();

  void _totalBudget() {
    setState(() {
      _Budget.write("overallBudget", totalAmonut);
    });
  }

  void _showBottomSheet(BuildContext context) {
    // Temporary list and total for the bottom sheet
    List<Map<String, dynamic>> tempBudgetList = [];
    double tempTotal = 0.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add Budget",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Dropdown for single category selection
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      hint: Text("Select Category"),
                      items:
                          _categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Amount input field
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter Amount",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Add to List button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 239, 217, 22),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_selectedCategory != null &&
                            _amountController.text.isNotEmpty) {
                          double amount = double.parse(_amountController.text);
                          setState(() {
                            tempBudgetList.add({
                              "category": _selectedCategory,
                              "amount": amount,
                            });
                            tempTotal += amount;
                            _selectedCategory = null; // Reset category
                            _amountController.clear(); // Clear input
                          });
                        }
                      },
                      child: const Text(
                        "Add to List",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Display list of added budgets and total
                    if (tempBudgetList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Added Budgets:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: tempBudgetList.length,
                            itemBuilder: (context, index) {
                              final item = tempBudgetList[index];
                              return ListTile(
                                title: Text(item["category"]),
                                subtitle: Text(
                                  "\₹${item["amount"].toStringAsFixed(2)}",
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Total: \₹${tempTotal.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 20),

                    // Submit button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellowAccent,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (tempBudgetList.isNotEmpty) {
                          setState(() {
                            totalAmonut += tempTotal; // Update global total
                            _budgetList.addAll(
                              tempBudgetList,
                            ); // Add to main list
                            _totalBudget(); // Save to storage
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BudgetSummaryScreen(
                                    budgetList: _budgetList,
                                    responseData: [],
                                  ),
                            ),
                          );
                        }
                      },

                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Expenses",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 239, 217, 22),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => _showBottomSheet(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    "Add Expenses",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child:
                  _budgetList.isEmpty
                      ? Center(
                        child: Text(
                          "No budgets added yet!",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: _budgetList.length,
                        itemBuilder: (context, index) {
                          final item = _budgetList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                item["category"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "\₹${item["amount"].toStringAsFixed(2)}",
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _totalBudget;
                                    item["amount"]; // Update global total
                                    _budgetList.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
            ),

            // Display Global Total Budget
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.yellowAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Budget:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "\₹${totalAmonut.toStringAsFixed(2)}", // Format to 2 decimal places
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
