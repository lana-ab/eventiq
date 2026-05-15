import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/eventservices/serviceModel.dart';
import 'package:untitled2/eventservices/getServices.dart';

class ServiceController extends GetxController {
  final int eventId;
  ServiceController(this.eventId);

  var servicesList = <ServiceModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServicesByEvent();
  }

  Future<void> fetchServicesByEvent() async {
    try {
      isLoading.value = true;

      final token = await _getToken();
      final services = await GetServices()
          .getServices(token: token, companyEventsId: eventId);

      servicesList.assignAll(services);

      for (var service in services) {
        final imagePath = await GetServices()
            .getServiceImage(token: token, serviceId: service.serviceId);
        updateServiceImage(service.serviceId, imagePath);
      }
    } catch (e) {
      print("Error fetching services: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateServiceImage(int serviceId, String imagePath) {
    int index = servicesList.indexWhere((s) => s.serviceId == serviceId);
    if (index != -1) {
      final updatedService = servicesList[index].copyWith(image: imagePath);
      servicesList[index] = updatedService;
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }
}