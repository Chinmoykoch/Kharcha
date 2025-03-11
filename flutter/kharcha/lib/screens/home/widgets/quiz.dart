import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kharcha/screens/analytics/analytics.dart';
import '../widgets/personal_assistant.dart';

final GetStorage storage = GetStorage();

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int globalPoints = 0;

  final List<Map<String, dynamic>> quizzes = [
    {
      'question': 'What is your first step in a financial crisis?',
      'options': [
        'Cut non-essential expenses',
        'Take a loan',
        'Use emergency savings',
        'Ignore and hope for the best',
      ],
      'selected': <String>[],
    },
    {
      'question': 'How do you prioritize debt repayment during a crisis?',
      'options': [
        'Pay off high-interest debt first',
        'Pay minimum on all debts',
        'Focus on small debts first',
        'Ignore debts temporarily',
      ],
      'selected': <String>[],
    },
  ];

  int currentQuizIndex = 0;

  @override
  void initState() {
    super.initState();
    globalPoints = storage.read('points') ?? 0;
  }

  void _onNextOrSubmit() {
    setState(() {
      if (currentQuizIndex < quizzes.length - 1) {
        currentQuizIndex++;
      } else {
        globalPoints += 18;
        storage.write('points', globalPoints);
        _showFinancialAdviceDialog();
      }
    });
  }

  void _showFinancialAdviceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Financial Advice"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "To navigate a financial crisis, start by cutting non-essential expenses and managing debt wisely. Build an emergency fund covering 3–6 months of expenses. Seek professional financial advice to avoid costly mistakes.",
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                "You earned points!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: globalPoints),
                duration: const Duration(seconds: 2),
                builder: (context, value, child) {
                  return Text(
                    "+$value Points",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeaderboardScreen(),
                  ),
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuiz = quizzes[currentQuizIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Financial Quiz',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (currentQuizIndex + 1) / quizzes.length,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.yellowAccent,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: const Color(0xFF1E1E1E),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${currentQuizIndex + 1}: ${currentQuiz['question']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...currentQuiz['options'].map<Widget>((option) {
                      return CheckboxListTile(
                        title: Text(
                          option,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        value: currentQuiz['selected'].contains(option),
                        onChanged: (bool? value) {
                          setState(() {
                            List<String> updatedSelection = List<String>.from(
                              currentQuiz['selected'],
                            );
                            if (value == true) {
                              updatedSelection.add(option);
                            } else {
                              updatedSelection.remove(option);
                            }
                            currentQuiz['selected'] = updatedSelection;
                          });
                        },
                        activeColor: Colors.yellowAccent,
                        checkColor: Colors.black,
                        tileColor: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentQuizIndex > 0)
                  ElevatedButton(
                    onPressed: () => setState(() => currentQuizIndex--),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                    ),
                    child: const Text(
                      'Previous',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ElevatedButton(
                  onPressed: _onNextOrSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellowAccent,
                  ),
                  child: Text(
                    currentQuizIndex == quizzes.length - 1 ? 'Submit' : 'Next',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
