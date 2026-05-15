import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/home/HomeScreen.dart';
import '../../services/auth_service.dart';

class EmailVerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  void verifyCode() async {
    final code = otpController.text.trim();
    if (code.isEmpty || code.length < 6) {
      errorMessage.value = "Please enter a valid 6-digit code.";
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    final token = await AuthService.getToken();
    if (token == null) {
      errorMessage.value = "Missing token. Please log in again.";
      isLoading.value = false;
      return;
    }

    final success = await AuthService.verifyCode(code);

    isLoading.value = false;

    if (success) {
      Get.snackbar("Success", "Your email has been verified",
          snackPosition: SnackPosition.BOTTOM);
      Get.offAll(() => const HomeScreen());
    } else {
      errorMessage.value = "Invalid code. Please try again.";
    }
  }

  void resendCode() async {
    final token = await AuthService.getToken();
    if (token == null) {
      Get.snackbar("Error", "Missing token. Please log in again.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final success = await AuthService.sendVerificationCode();

    if (success) {
      Get.snackbar("Code Resent", "A new verification code has been sent.",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar("Error", "Failed to resend verification code.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}

class EmailVerificationScreen extends StatelessWidget {
  final String email;

  const EmailVerificationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmailVerificationController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDEBFA), Color(0xFFBCAEF3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  "Verify Your Email",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3C9A),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "We have sent a verification code to:",
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4A3C9A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: controller.otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    letterSpacing: 8,
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "Enter Code",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                Obx(() => controller.errorMessage.value.isNotEmpty
                    ? Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
                    : const SizedBox.shrink()),
                const SizedBox(height: 30),
                Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: controller.verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C69C1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text("VERIFY"),
                )),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: controller.resendCode,
                  child: const Text(
                    "Resend Code",
                    style: TextStyle(
                      color: Color(0xFF4A3C9A),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
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
