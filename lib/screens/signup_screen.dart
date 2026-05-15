import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  static final adminNameController = TextEditingController();
  static final adminEmailController = TextEditingController();
  static final adminPasswordController = TextEditingController();
  static final adminConfirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity, // ضروري لإزالة الفراغ الأبيض
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEDEBFA), // موف فاتح
              Color(0xFFBCAEF3), // موف متوسط
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 35),

                  SizedBox(
                    height: 150,
                    child: Image.asset(
                      'assets/photo_2025-05-20_20-47-33-removebg-preview.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 23),

                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Welcome to Eventiq!',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A3C9A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'create your account',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Full Name
                  TextField(
                    controller: adminNameController,
                    decoration: InputDecoration(
                      hintText: 'Full name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email
                  TextField(
                    controller: adminEmailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password
                  TextField(
                    controller: adminPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password
                  TextField(
                    controller: adminConfirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: () {
                      authController.signup(
                        name: adminNameController.text.trim(),
                        email: adminEmailController.text.trim(),
                        password: adminPasswordController.text,
                        confirmPassword:
                        adminConfirmPasswordController.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C69C1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    child: const Center(child: Text('SIGN UP')),
                  ),
                  const SizedBox(height: 20),

                  // Already have account
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.black87),
                        children: [
                          TextSpan(
                            text: "log in",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A3C9A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
