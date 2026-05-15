import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class AuthService {
  static const String tokenKey = 'auth_token';

  // تسجيل الدخول
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('LOGIN STATUS CODE: ${response.statusCode}');
      print('LOGIN RESPONSE BODY: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(tokenKey, token);
        print("🟢 New token saved: $token");

        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Exception: $e'};
    }
  }


  // استرجاع التوكن المحفوظ
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);
    print("📦 Retrieved token: $token");
    return token;
  }

  // تسجيل الحساب
  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
          'role': 'admin',
        }),
      );

      print('SIGNUP STATUS CODE: ${response.statusCode}');
      print('SIGNUP BODY: ${response.body}');

      final data = jsonDecode(response.body);
      print("📩 Signup Response: $data");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(tokenKey, token);
        print("🟢 Token saved after signup: $token");

        await sendVerificationCode();
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'data': data};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error occurred: $e'};
    }
  }

  static Future<bool> sendVerificationCode() async {
    final token = await getToken();
    if (token == null) return false;

    final url = Uri.parse(ApiConstants.sendVerificationCode);
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print("Verification code sent: ${response.body}");
      return true;
    } else {
      print("Failed to resend code: ${response.body}");
      return false;
    }
  }

  static Future<bool> verifyCode(String code) async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final response = await http.post(
        Uri.parse(ApiConstants.verifyCode),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'code': code}),
      );

      print('VERIFY RESPONSE: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print("Error verifying code: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/requestPasswordReset'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'email': email},
      );

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'message': data['message'] ?? 'No message',
        'data': data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Exception occurred',
        'error': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/resetPassword');

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': email,
          'code': code,
          'password': password,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        final message = data['message'] ?? data['error'] ?? 'Unknown error occurred';
        return {
          'success': false,
          'message': message,
          'data': data,
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error occurred: $e'};
    }
  }

  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey) ?? '';

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await prefs.remove(tokenKey);
        print("🟢 Logout successful and token cleared.");
        return true;
      } else {
        print('Logout failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }
}
