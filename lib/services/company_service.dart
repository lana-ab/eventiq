import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CompanyService {
  static Future<List<dynamic>> fetchCompanies() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) return [];

    final url = Uri.parse('https://yourdomain.com/api/showProviders');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['providers'] ?? data; // تأكد حسب الباك
    } else {
      throw Exception('فشل في تحميل الشركات');
    }
  }
}
