// controllers/event_selection_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/booking_service.dart';

class EventSelectionController extends GetxController {
  var events = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchEvents();
    super.onInit();
  }

  Future<void> fetchEvents() async {
    isLoading.value = true;
    final data = await BookingService.getEvents();
    if (data != null) events.value = data;
    isLoading.value = false;
  }

  Future<void> selectEvent(int eventId) async {
    final success = await BookingService.selectEvent(eventId);
    if (success) {
      Get.snackbar("Success", "Event selected successfully",
          backgroundColor: const Color(0xFF7C69C1), colorText: Get.theme.canvasColor);
      // تابع للخطوة التالية أو الشاشة القادمة
    } else {
      Get.snackbar("Error", "Failed to select event",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
