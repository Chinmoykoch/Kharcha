import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kharcha/constants.dart';

class Api {
  static const String _baseUrl =
      'https://aa2d-2401-4900-b233-442e-1c68-d42b-f0d9-5141.ngrok-free.app';

  // Signup method
  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String phoneNumber,
    String password,
  ) async {
    try {
      final Map<String, String> bodyData = {
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/auth/sign-up'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      debugPrint('Signup Request: ${jsonEncode(bodyData)}');
      debugPrint('Response Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Signup failed: ${response.body}");
      }
    } catch (e) {
      debugPrint('Signup Error: $e');
      return {"error": "Error during signup: $e"};
    }
  }

  // Login method
  Future<Map<String, dynamic>> login(
    String phoneNumber,
    String password,
  ) async {
    try {
      final Map<String, String> bodyData = {
        "phoneNumber": phoneNumber,
        "password": password,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/auth/sign-in'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      debugPrint('Login Request: ${jsonEncode(bodyData)}');
      debugPrint('Response Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        final responseData = jsonDecode(response.body);
        GetStorage().write('userId', responseData['user']['id'].toString());

        return responseData;
      } else {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      debugPrint('Login Error: $e');
      return {"error": "Error during login: $e"};
    }
  }

  Future<Map<String, dynamic>?> fetchBalance() async {
    String? myValue = GetStorage().read('userId');
    print(myValue);

    try {
      final bodyData = {"userId": myValue};
      final response = await http.post(
        Uri.parse("$_baseUrl/api/v1/auth/singleuser"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        print("Failed to load balance: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching balance: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> budget() async {
    String? myValue = GetStorage().read('userId');

    try {
      final bodyData = {"userId": myValue};
      final response = await http.post(
        Uri.parse("$_baseUrl/api/v1/budget/get"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        print("Failed to load balance: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching balance: $e");
      return null;
    }
  }

  // Fetch all transactions
  Future<Map<String, dynamic>> allTransaction() async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/medicine/getmedicinebyuser');

      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      debugPrint('Transaction Response Code: ${response.statusCode}');
      debugPrint('Transaction Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      debugPrint('Transaction Fetch Error: $e');
      return {"error": "Error fetching transactions: $e"};
    }
  }

  // Post receipt
  Future<Map<String, dynamic>> postReceipt(String Receipt) async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: {'receipt': Receipt},
      );

      debugPrint('Receipt Upload Response Code: ${response.statusCode}');
      debugPrint('Receipt Upload Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      debugPrint('Receipt Upload Error: $e');
      return {"error": "Error uploading receipt: $e"};
    }
  }

  Future<Map<String, dynamic>> startChat() async {
    final url = Uri.parse('$_baseUrl/api/v1/');
    final response = await http.post(
      url,
      body: {'userId': AppConstants.userId ?? ""},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to start chat: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> sendAnswer(
    String sessionId,
    String answer,
  ) async {
    final url = Uri.parse('$_baseUrl/api/mood/answer/$sessionId?isQuiz=false');
    final response = await http.post(url, body: {'answer': answer});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send answer: ${response.statusCode}');
    }
  }
}
