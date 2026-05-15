import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatelessWidget {
  final double totalAmount;
  final String bookingId;
  const PaymentScreen({super.key, required this.totalAmount, required this.bookingId});

  Future<void> _launchStripePayment() async {
    final url = 'https://your-stripe-url.com/checkout'; // تبديله برابط الدفع الحقيقي

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('خطأ', 'تعذر فتح رابط الدفع');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدفع الإلكتروني'),
        backgroundColor: const Color(0xFF4A3F7A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Total Amount :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '$totalAmount \$',
              style: const TextStyle(fontSize: 28, color: Color(0xFF6A4BBC)),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _launchStripePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A4BBC),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'ادفع الآن',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
