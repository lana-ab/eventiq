import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class SimpleStripeScreen extends StatefulWidget {
  const SimpleStripeScreen({super.key});

  @override
  State<SimpleStripeScreen> createState() => _SimpleStripeScreenState();
}

class _SimpleStripeScreenState extends State<SimpleStripeScreen> {
  final CardFormEditController _cardFormController = CardFormEditController();
  String? _paymentMethodId;
  String? _status;

  Future<void> _createPaymentMethod() async {
    if (!_cardFormController.details.complete) {
      setState(() {
        _status = 'يرجى تعبئة بيانات البطاقة كاملة';
      });
      return;
    }

    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: 'Test User',
              email: 'test@example.com',
            ),
          ),
        ),
      );

      setState(() {
        _paymentMethodId = paymentMethod.id;
        _status = '✅ تم توليد Payment Method بنجاح';
      });

      print('Payment Method ID: ${paymentMethod.id}');
    } catch (e) {
      setState(() {
        _status = '❌ فشل في التوليد: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe - فقط توليد Payment Method')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('أدخل بيانات البطاقة:'),
            const SizedBox(height: 10),
            CardFormField(
              controller: _cardFormController,
              style: CardFormStyle(
                borderColor: Colors.grey,
                textColor: Colors.black,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createPaymentMethod,
              child: const Text('توليد Payment Method'),
            ),
            const SizedBox(height: 20),
            if (_paymentMethodId != null) Text('ID: $_paymentMethodId'),
            if (_status != null) Text(_status!, style: const TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
