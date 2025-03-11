import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kharcha/api.dart';
import 'package:kharcha/navigation.dart';
import 'package:kharcha/screens/auth/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Phone number and password are required",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await Api().login(
        phoneController.text,
        passwordController.text,
      );

      if (response != null && response.isNotEmpty) {
        Get.offAll(() => const NavigationScreen());
      } else {
        Get.snackbar(
          "Login Failed",
          "Invalid phone number or password",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
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
      body: Center(
        child: SingleChildScrollView(
          // Prevents overflow issues
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sign in to take control of your finances",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    color: Colors.black,
                  ), // Text color set to black
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    hintStyle: TextStyle(
                      color: Colors.black87,
                    ), // Hint text color
                    filled: true,
                    fillColor: const Color.fromRGBO(
                      255,
                      255,
                      255,
                      1,
                    ), // Background color changed to white for visibility
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(
                    color: Colors.black,
                  ), // Text color set to black
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: Colors.black87,
                    ), // Hint text color
                    filled: true,
                    fillColor:
                        Colors
                            .white, // Background color changed to white for visibility
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black, // Corrected text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.black,
                            )
                            : const Text(
                              "Login",
                              style: TextStyle(fontSize: 18),
                            ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "or",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                TextButton(
                  onPressed:
                      () => Get.to(
                        () => const SignupScreen(),
                        transition: Transition.fade,
                      ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
