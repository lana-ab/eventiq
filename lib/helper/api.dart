import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  Future<dynamic> get({required String url, required String token}) async {
    print("📡 Calling GET: $url");
    print("🔑 Token being sent: $token");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    print("GET ${response.statusCode}: ${response.body}");

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw Exception("خطأ في تفكيك البيانات: $e");
      }
    } else if (response.statusCode == 404) {
      throw Exception("NOT_FOUND");
    } else {
      throw Exception("فشل الطلب ${response.statusCode}");
    }
  }


  Future<dynamic> post({
    required String url,
    required Map<String, String> body,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: body,
    );

    print("POST ${response.statusCode}: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("فشل الطلب: ${response.statusCode}");
    }
  }

  Future<dynamic> patch({
    required String url,
    required Map<String, String> body,
    required String token,
  }) async {
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: body,
    );

    print("PATCH ${response.statusCode}: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("فشل التعديل: ${response.statusCode}");
    }
  }
}
