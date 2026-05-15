import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/home/companyModel.dart';
import 'package:untitled2/services/api_constants.dart'; // <-- استدعاء ملف API

class CompanySearchController  extends GetxController {
  var isLoading = false.obs;
  var searchResults = <CompanyModel>[].obs;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isLoading.value = true;

      // 🔹 جلب التوكن من SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      if (token == null || token.isEmpty) {
        print('No token found.');
        searchResults.clear();
        return;
      }

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/company/search"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'query': query}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['companies'];
        searchResults.value =
            data.map((e) => CompanyModel.fromJson(e)).toList();
      } else {
        searchResults.clear();
      }
    } catch (e) {
      print('Search error: $e');
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
