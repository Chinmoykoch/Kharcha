import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kharcha/api.dart';
import 'package:kharcha/navigation.dart';
import 'package:kharcha/screens/auth/login.dart';
import 'package:kharcha/screens/home/homepage.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isNotValidate = false;
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleSignup() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      setState(() => _isNotValidate = true);
      Get.snackbar(
        "Error",
        "All fields are required",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isNotValidate = false;
      _isLoading = true;
    });

    try {
      final response = await Api().signup(
        nameController.text,
        emailController.text,
        phoneController.text,
        passwordController.text,
      );

      if (response != null && response.isNotEmpty) {
        Get.snackbar(
          "Success",
          "Signup successful",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => NavigationScreen());
        });
      } else {
        Get.snackbar(
          "Signup Failed",
          response["message"] ?? "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Signup Error",
        "$e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Full Name",
                  errorText:
                      _isNotValidate && nameController.text.isEmpty
                          ? "Full Name is required"
                          : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  errorText:
                      _isNotValidate && emailController.text.isEmpty
                          ? "Email is required"
                          : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  errorText:
                      _isNotValidate && passwordController.text.isEmpty
                          ? "Password is required"
                          : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  errorText:
                      _isNotValidate && phoneController.text.isEmpty
                          ? "Phone No. is required"
                          : null,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : handleSignup,
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Sign Up"),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.to(() => const LoginScreen()),
                child: const Text(
                  "Already have an account? Log in",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
