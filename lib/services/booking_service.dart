// services/booking_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_constants.dart';

class BookingService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List?> getEvents() async {
    final token = await getToken();
    final url = Uri.parse('${ApiConstants.baseUrl}/showEvents');

    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  static Future<bool> selectEvent(int eventId) async {
    final token = await getToken();
    final url = Uri.parse('${ApiConstants.baseUrl}/selectEvent');

    final response = await http.post(url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'event_id': eventId.toString(),
        });

    return response.statusCode == 200;
  }
}
