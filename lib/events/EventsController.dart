import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/events/eventsModel.dart';
import 'package:untitled2/events/getEvents.dart';


class EventController extends GetxController {
  final int companyId;

  EventController({required this.companyId});

  var eventsList = <EventsModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      isLoading(true);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';


      if (token.isEmpty) {
        throw Exception("Token not found.");
      }
      print("🔑 Token loaded from SharedPreferences: $token");
      print("📡 Fetching events for company $companyId");
      print("🔑 Token used in EventsController: $token");

      final events = await GetEvents().getEvents(
        token: token,
        companyId: companyId,
      );

      if (events.isNotEmpty) {
        eventsList.assignAll(events);
      } else {
        Get.snackbar("Notice", "No events available",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("❌ Error in fetchEvents: $e");
      Get.snackbar("Error", "Failed to load events",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }}
