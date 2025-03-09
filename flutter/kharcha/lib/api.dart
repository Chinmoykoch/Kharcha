import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  static const String _baseUrl =
      'https://5f5b-2401-4900-1c3b-e7aa-f519-df53-1407-db3d.ngrok-free.app';

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
        return jsonDecode(response.body);
      } else {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      debugPrint('Login Error: $e');
      return {"error": "Error during login: $e"};
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
      final url = Uri.parse('$_baseUrl/api/v1/receipt/upload');

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
}
