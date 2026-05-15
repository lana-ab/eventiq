import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';
import '../services/api_constants.dart';

class ServiceSelectionController extends GetxController {
  final int companyEventsId;

  ServiceSelectionController(this.companyEventsId);

  var services = [].obs;
  var isLoading = false.obs;

  // حفظ الكميات لكل خدمة
  var quantities = <int, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      isLoading.value = true;
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/showServices?company_event_id=$companyEventsId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        services.value = data['services'] ?? [];

        // تهيئة الكميات الافتراضية
        for (var service in services) {
          quantities[service['id']] = 1;
        }
      } else {
        print("📛 Failed to load services: ${data['message']}");
      }
    } catch (e) {
      print("📛 Error fetching services: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void increaseQuantity(int serviceId) {
    quantities[serviceId] = (quantities[serviceId] ?? 1) + 1;
  }

  void decreaseQuantity(int serviceId) {
    if ((quantities[serviceId] ?? 1) > 1) {
      quantities[serviceId] = (quantities[serviceId] ?? 1) - 1;
    }
  }

  Future<void> selectService(int serviceId) async {
    try {
      isLoading.value = true;
      final token = await AuthService.getToken();

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/selectService'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': serviceId,
          'service_quantity': quantities[serviceId] ?? 1, // إرسال الكمية المحددة
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar("✅ Success", "Service selected successfully",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar(
          "❌ Error",
          data['message'] ?? "Selection failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      print("📛 Error selecting service: $e");
      Get.snackbar(
        "❌ Error",
        "An error occurred while selecting service",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
