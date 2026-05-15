import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UnifiedPaymentScreen extends StatefulWidget {
  final double totalAmount;
  final String bookingId;

  const UnifiedPaymentScreen({
    super.key,
    required this.totalAmount,
    required this.bookingId,
  });

  @override
  State<UnifiedPaymentScreen> createState() => _UnifiedPaymentScreenState();
}

class _UnifiedPaymentScreenState extends State<UnifiedPaymentScreen> {
  final CardFormEditController _cardFormController = CardFormEditController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _status;
  bool _isLoading = false;

  Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> _pay() async {
    if (!_cardFormController.details.complete) {
      setState(() {
        _status = 'يرجى تعبئة بيانات البطاقة كاملة';
      });
      return;
    }

    final token = await _getToken();
    if (token == null || token.isEmpty) {
      setState(() {
        _status = 'لم يتم تسجيل الدخول أو التوكن غير موجود';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _status = null;
    });

    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: 'اسم المستخدم',
              email: 'user@example.com',
            ),
          ),
        ),
      );

      final response = await http.post(
        Uri.parse(ApiConstants.payment),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'booking_id': widget.bookingId,
          'payment_method_id': paymentMethod.id,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final checkoutUrl = data['checkout_url'] as String?;

        if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
          setState(() {
            _status = 'جاري تحويلك لصفحة الدفع...';
          });

          if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
            await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.externalApplication);
          } else {
            setState(() {
              _status = 'تعذر فتح رابط الدفع';
            });
          }
        } else {
          setState(() {
            _status = 'لم يتم استلام رابط الدفع من الخادم';
          });
        }
      } else {
        setState(() {
          _status = 'خطأ من الخادم: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'حدث خطأ: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEDEBFA),
              Color(0xFFBCAEF3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ✅ Custom Header with Back Button and Title
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Online Payment',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A4BBC),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text('Total Amount :', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('${widget.totalAmount} \$', style: const TextStyle(fontSize: 28, color: Color(0xFF6A4BBC))),
                  const SizedBox(height: 20),
                  const Text('Enter Card Details :', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  CardFormField(
                    controller: _cardFormController,
                    style:  CardFormStyle(
                      borderColor: Colors.grey,
                      textColor: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _pay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A4BBC),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Pay Now', style: TextStyle(fontSize: 22, color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                  if (_status != null)
                    Text(
                      _status!,
                      style: TextStyle(
                        color: _status!.startsWith('✅') ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
