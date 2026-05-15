import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';
import '../services/api_constants.dart';

class UnifiedServicesController extends GetxController {

  var services = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  late String bookingId;
  late int companyEventsId;

  final selectedServiceIds = <int>{}.obs;
  static const String imageBaseUrl = "http://10.0.2.2:8000/storage";



  void setBookingId(String id, int companyEventId) {
    bookingId = id;
    companyEventsId = companyEventId;
  }

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    try {
      final token = await AuthService.getToken();
      print("📦 Token: $token");
      print("📡 Requesting services for companyEventsId: $companyEventsId");

      // 🟢 جلب الخدمات
      final response = await http.get(
        Uri.parse('${ApiConstants.showServices}?company_events_id=$companyEventsId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("📥 Services Status Code: ${response.statusCode}");
      print("📥 Services Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> serviceList = jsonDecode(response.body);
        final List<Map<String, dynamic>> parsedServices =
        List<Map<String, dynamic>>.from(serviceList);

        print("✅ Parsed ${parsedServices.length} services");

        // 🟢 جلب الصور لكل خدمة
        for (var service in parsedServices) {
          final serviceId = service['id'];

          print("📡 Requesting image for service_id: $serviceId");

          final imageResponse = await http.get(
            Uri.parse('${ApiConstants.servicesGetImage}?service_id=$serviceId'),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          );

          print("🖼️ Image Response Status: ${imageResponse.statusCode}");

          if (imageResponse.statusCode == 200) {
            final imageData = jsonDecode(imageResponse.body);
            final images = List<Map<String, dynamic>>.from(imageData['images']);

            if (images.isNotEmpty) {
              final fullImageUrl = "$imageBaseUrl/${images.first['image_url']}";

              service['image_url'] = fullImageUrl;
              print("🔗 Attached image to service $serviceId");
            } else {
              service['image_url'] = null;
              print("❌ No image found for service $serviceId");
            }
          } else {
            service['image_url'] = null;
            print("❌ Failed to fetch image for service $serviceId");
          }
        }

        services.value = parsedServices;
      } else {
        Get.snackbar("Error", "Could not fetch services");
        print("❌ Failed to fetch services. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception in fetchServices: $e");
      Get.snackbar("Error", "An error occurred while loading services");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectService(int serviceId) async {
    final token = await AuthService.getToken();

    if (selectedServiceIds.contains(serviceId)) {
      // 🔁 تم اختياره من قبل → نحذفه من الباكيند
      await deselectService(serviceId);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.selectService),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': serviceId,
          'service_quantity': 1,
          'booking_id': bookingId,
        }),
      );

      final data = jsonDecode(response.body);
      print("📨 SelectService Status Code: ${response.statusCode}");
      print("📨 SelectService Response Body: $data");

      if (response.statusCode == 200 || response.statusCode == 201) {
        selectedServiceIds.add(serviceId);
        Get.snackbar("✅ Success", "Service selected successfully", snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("❌ Error", data['message'] ?? "Selection failed", snackPosition: SnackPosition.BOTTOM);
      }

    } catch (e) {
      print("📛 Error selecting service: $e");
      Get.snackbar("❌ Error", "An error occurred while selecting service", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deselectService(int serviceId) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.Request(
        'DELETE',
        Uri.parse(ApiConstants.deleteServiceBooking),
      )
        ..headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        })
        ..body = jsonEncode({
          'booking_id': bookingId,
          'service_id': serviceId,
        });

      final streamedResponse = await response.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      print("🗑️ DeselectService Status: ${streamedResponse.statusCode}");
      print("🗑️ DeselectService Response: $responseBody");

      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 204) {
        selectedServiceIds.remove(serviceId);
        Get.snackbar("Removed", "Service deselected successfully", snackPosition: SnackPosition.BOTTOM);
      } else {
        final data = jsonDecode(responseBody);
        Get.snackbar("Error", data['message'] ?? "Failed to deselect service", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("📛 Error deselecting service: $e");
      Get.snackbar("Error", "An error occurred while removing the service", snackPosition: SnackPosition.BOTTOM);
    }
  }

  List<Map<String, dynamic>> get selectedServices {
    return services.where((service) => selectedServiceIds.contains(service['id'])).map((service) {
      return {
        'service_id': service['id'],
        'service_name': service['service_name'],
        'service_description': service['service_description'],
        'service_price': service['service_price'],
        'quantity': 1,
        'image_url': service['image_url'],
      };
    }).toList();
  }
}
