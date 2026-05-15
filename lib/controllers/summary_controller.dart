import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SummaryController extends GetxController {
  // اسم الفعالية
  final eventName = ''.obs;

  // اسم الصالة
  final venueName = ''.obs;

  // قائمة الخدمات المختارة
  final selectedServices = <Map<String, dynamic>>[].obs;

  // السعر الإجمالي
  double get totalPrice {
    double total = 0.0;
    for (var service in selectedServices) {
      final price = double.tryParse(service['service_price'].toString()) ?? 0.0;
      total += price;
    }
    return total;
  }

  // تحميل البيانات من الواجهة السابقة
  void initialize({
    required String event,
    required String venue,
    required List<Map<String, dynamic>> services,
  }) {
    eventName.value = event;
    venueName.value = venue;
    selectedServices.assignAll(services);
  }
}
