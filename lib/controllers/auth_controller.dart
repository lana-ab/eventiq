import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/HomeCompanyController.dart';
import '../screens/EmailVerificationScreen.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  // 🟣 تسجيل الدخول
  Future<void> login(String email, String password) async {
    isLoading.value = true;

    final result = await AuthService.login(email, password);

    isLoading.value = false;

    if (result['success']) {
      final token = await AuthService.getToken();
      print("🟢 Token after login: $token");
      Get.put(HomeCompanyController()).getCompanies();
      Get.snackbar("Success", "Logged in successfully",
          snackPosition: SnackPosition.BOTTOM);
      // انتقل للصفحة الرئيسية أو صفحة التحقق
      // Get.offAll(() => HomeScreen());
    } else {
      Get.snackbar("Error", result['data']['message'] ?? "Login failed",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // 🟣 إنشاء حساب
  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    isLoading.value = true;

    final result = await AuthService.signup(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    isLoading.value = false;

    if (result['success']) {

      Get.snackbar("Success", "Account created successfully",
          snackPosition: SnackPosition.BOTTOM);
      print("✅ Signup Successful: $result");
      // انتقل لواجهة التحقق أو تسجيل الدخول
      Get.off(() => EmailVerificationScreen(email: email ));
    } else {
      Get.snackbar("Error", result['data']['message'] ?? "Signup failed",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      print("❌ Signup Error: $result");
    }
  }

// 🟣 إعادة تعيين كلمة المرور
  Future<void> resetPassword(String email, String code, String password) async {
    isLoading.value = true;

    final result = await AuthService.resetPassword(
      email: email,
      code: code,
      password: password,
    );

    isLoading.value = false;

    if (result['success']) {
      Get.snackbar("Success", "Password reset successfully",
          snackPosition: SnackPosition.BOTTOM);
      // مثلاً تنقل لصفحة تسجيل الدخول
      // Get.off(() => LoginScreen());
    } else {
      Get.snackbar("Error", result['data']['message'] ?? "Password reset failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

}