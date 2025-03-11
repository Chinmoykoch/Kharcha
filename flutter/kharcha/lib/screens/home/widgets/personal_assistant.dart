// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ChatbotApp extends StatefulWidget {
//   @override
//   _ChatbotAppState createState() => _ChatbotAppState();
// }

// class _ChatbotAppState extends State<ChatbotApp> {
//   TextEditingController _controller = TextEditingController();
//   String response = "";

//   void sendMessage() async {
//     final url = Uri.parse(
//       "https://aa2d-2401-4900-b233-442e-1c68-d42b-f0d9-5141.ngrok-free.app/api/v1/chat",
//     );
//     final res = await http.post(
//       url,
//       body: jsonEncode({"message": _controller.text}),
//       headers: {"Content-Type": "application/json"},
//     );
//     final data = jsonDecode(res.body);
//     setState(() {
//       response = data["response"];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Out Financial Advisor")),
//         body: Column(
//           children: [
//             TextField(controller: _controller),
//             ElevatedButton(onPressed: sendMessage, child: Text("Send")),
//             Text("Bot: $response"),
//           ],
//         ),
//       ),
//     );
//   }
// }
