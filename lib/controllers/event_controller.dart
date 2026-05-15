/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/services/api_constants.dart'; // تأكد من مسار الملف الصحيح

class EventController extends GetxController {
  // ✅ التاريخ
  var selectedDate = Rxn<DateTime>();
  final TextEditingController dateController = TextEditingController();

  void setDate(DateTime date) {
    selectedDate.value = date;
    dateController.text = DateFormat('yyyy-MM-dd').format(date);
  }

  // ✅ عدد المدعوين
  var numberOfInvites = 0.obs;

  // ✅ الموقع
  var selectedLocation = ''.obs;
  var availableLocations = <String>[
    'صالة 1',
    'صالة 2',
    'موقع 3',
  ].obs;

  void addCustomLocation(String location) {
    availableLocations.add(location);
    selectedLocation.value = location;
  }

  // ✅ نوع الفعالية
  var selectedEventType = ''.obs;
  var availableEventTypes = <String>[
    'عيد ميلاد',
    'حفل زفاف',
    'اجتماع',
    'تخرج',
  ];

  // ✅ الشركة المنظمة
  var selectedCompany = ''.obs;
  var availableCompanies = <String>[
    'شركة 1 ',
    'شركة2',
    'شركة 3',
  ];

  // ✅ الخدمات المختارة
  var selectedServices = <String>[].obs;

  void toggleService(String service) {
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }
  }

  void updateSelectedServices(List<String> services) {
    selectedServices.assignAll(services);
  }

  // ✅ إرسال الحجز إلى السيرفر
  Future<void> createBooking() async {
    if (selectedDate.value == null || numberOfInvites.value == 0) {
      Get.snackbar('Error', 'Please complete all fields');
      return;
    }

    final date = selectedDate.value!;
    final dateString = DateFormat('yyyy/MM/dd').format(date);
    final startTime = DateFormat('HH:mm').format(date);
    final endTime = DateFormat('HH:mm').format(date.add(Duration(hours: 2)));

    final url = Uri.parse(
      '${ApiConstants.baseUrl}/createBooking'
          '?start_time=$startTime'
          '&end_time=$endTime'
          '&booking_date=$dateString'
          '&number_of_invites=${numberOfInvites.value}',
    );

    const token = 'your_token_here'; // ضع التوكن الصحيح هنا أو اجلبه من التخزين

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Booking created successfully');
        print('Response: ${response.body}');

        // الانتقال إلى صفحة اختيار الخدمات
        Get.toNamed('/select-services');
      } else {
        print('Error: ${response.body}');
        Get.snackbar('Error', 'Booking failed: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Exception', 'Something went wrong');
      print('Exception: $e');
    }
  }

  // ✅ إعادة تعيين الحقول
  void clearAll() {
    selectedDate.value = null;
    dateController.clear();
    selectedLocation.value = '';
    selectedEventType.value = '';
    selectedCompany.value = '';
    selectedServices.clear();
    numberOfInvites.value = 0;
  }

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }
}
*/