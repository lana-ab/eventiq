import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/summary_controller.dart';
import 'UnifiedPaymentScreen.dart';

class SummaryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedServices;
  final String eventName;
  final String venueName;
  final String bookingId;

  SummaryScreen({
    Key? key,
    required this.selectedServices,
    required this.eventName,
    required this.venueName,
    required this.bookingId,
  }) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final SummaryController controller = Get.put(SummaryController());

  @override
  void initState() {
    super.initState();
    // تهيئة البيانات مرة واحدة فقط
    controller.initialize(
      event: widget.eventName,
      venue: widget.venueName,
      services: widget.selectedServices,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEDEBFA),
              Color(0xFFBCAEF3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // زر العودة
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF4A3F7A), size: 30),
                  onPressed: () => Get.back(),
                ),

                const SizedBox(height: 12),

                // العنوان
                const Text(
                  "Booking Summary",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3F7A),
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 24),

                // محتوى قابل للتمرير
                Expanded(
                  child: Obx(() {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ListView(
                        children: [
                          _summaryItem("Event", controller.eventName.value),
                          const SizedBox(height: 12),
                          _summaryItem("Venue", controller.venueName.value),
                          const SizedBox(height: 24),
                          const Text(
                            "Selected Services:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A3F7A),
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 14),

                          if (controller.selectedServices.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Text(
                                  "No services selected.",
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          else
                            ...controller.selectedServices.map((service) {
                              return ListTile(
                                leading: const Icon(Icons.check_circle, color: Color(0xFF7C69C1)),
                                title: Text(
                                  service['service_name'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text("Price: \$${service['service_price']}"),
                              );
                            }).toList(),

                          const SizedBox(height: 30),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total Price:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A3F7A),
                                ),
                              ),
                              Text(
                                "\$${controller.totalPrice.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7C69C1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 25),

                // زر الدفع
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.selectedServices.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Please select at least one service before proceeding.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      Get.to(() => UnifiedPaymentScreen(
                        totalAmount: controller.totalPrice,
                        bookingId: widget.bookingId,
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C69C1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 8,
                    ),
                    child: const Text(
                      "confirm booking",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryItem(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title: ",
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4A3F7A),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 17),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
      ],
    );
  }
}
