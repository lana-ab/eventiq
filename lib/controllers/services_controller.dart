import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';

class ServicesController extends GetxController {
  var services = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  Future<void> fetchServicesWithImages(int companyEventsId) async {
    isLoading.value = true;
    try {
      final token = await AuthService.getToken();
      final baseUrl = 'http://10.0.2.2:8000';
      final url = '$baseUrl/api/showServices?company_events_id=$companyEventsId';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Map<String, dynamic>> loadedServices = [];

        for (var item in data) {
          Map<String, dynamic> service = Map<String, dynamic>.from(item);

          // طلب صورة لكل خدمة
          final imageResponse = await http.get(
            Uri.parse('$baseUrl/api/servicesGetImage?service_id=${service['id']}'),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          );

          if (imageResponse.statusCode == 200) {
            final imageData = jsonDecode(imageResponse.body);
            if (imageData is Map && imageData['images'] is List && imageData['images'].isNotEmpty) {
              final imagePath = imageData['images'][0]['image_url'];
              service['image'] = '$baseUrl/storage/$imagePath';
            } else {
              service['image'] = '';
            }
          } else {
            service['image'] = '';
          }

          loadedServices.add(service);
        }

        services.value = loadedServices;
      }
    } catch (e) {
      print("❌ Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
