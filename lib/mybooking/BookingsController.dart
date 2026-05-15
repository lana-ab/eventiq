import 'package:get/get.dart';

class BookingsController extends GetxController {
  // بيانات الحجز (تجي من الـ API بعد confirmBooking)
  var bookingId = ''.obs;
  var eventName = ''.obs;
  var companyName = ''.obs;
  var venueName = ''.obs;
  var services = <String>[].obs;
  var totalPrice = 0.0.obs;
  var status = 'Pending'.obs;

  // التقييم
  var rating = 0.obs;

  void setBookingData({
    required String id,
    required String event,
    required String company,
    required String venue,
    required List<String> selectedServices,
    required double price,
    required String bookingStatus,
  }) {
    bookingId.value = id;
    eventName.value = event;
    companyName.value = company;
    venueName.value = venue;
    services.assignAll(selectedServices);
    totalPrice.value = price;
    status.value = bookingStatus;
  }

  void setRating(int value) {
    rating.value = value;
  }

  void submitRating() {
    // مبدئيًا رح نخزن التقييم محليًا
    // إذا صار عندك API للتقييم ممكن تبعته هون
    print("✅ Booking ${bookingId.value} rated with ${rating.value} stars");
  }
}
