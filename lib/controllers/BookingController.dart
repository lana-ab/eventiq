import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../screens/CustomBookingScreen.dart';
import '../services/api_constants.dart';
import '../services/auth_service.dart'; // ✅ استخدام AuthService

class BookingController extends GetxController {
  var selectedDate = Rxn<DateTime>();
  var invitesCount = 0.obs;
  var bookingId = ''.obs;

  final dateController = TextEditingController();

  void setDate(DateTime date) {
    selectedDate.value = date;
    dateController.text = DateFormat('yyyy-MM-dd – HH:mm').format(date);
  }

  Future<void> createBooking() async {
    if (selectedDate.value == null || invitesCount.value <= 0) {
      Get.rawSnackbar(
        message: 'Please fill all fields',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final token = await AuthService.getToken(); // ✅ التوكن الصحيح من AuthService
    if (token == null || token.isEmpty) {
      Get.rawSnackbar(
        message: 'Authentication token missing. Please login first.',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // 🕒 تجهيز التاريخ والوقت
    final date = DateFormat('yyyy/MM/dd').format(selectedDate.value!);
    final start = DateFormat('h:mm a').format(selectedDate.value!);
    final end = DateFormat('h:mm a').format(selectedDate.value!.add(const Duration(hours: 2)));

    final url = Uri.parse(
      '${ApiConstants.baseUrl}/createBooking?'
          'start_time=$start&end_time=$end&booking_date=$date&number_of_invites=${invitesCount.value}',
    );

    try {
      print('📤 Sending request to: $url');
      print('🔐 Authorization: Bearer $token');

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Status Code: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['booking_id'] != null) {
          bookingId.value = data['booking_id'].toString();
          Get.to(() => CustomBookingScreen());
        } else {
          Get.rawSnackbar(
            message: 'Booking ID not returned from server.',
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.rawSnackbar(
          message: 'Booking failed: ${response.statusCode}',
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.rawSnackbar(
        message: 'An error occurred: $e',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }
}
