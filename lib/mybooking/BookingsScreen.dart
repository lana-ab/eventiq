import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/mybooking/BookingsController.dart';

class BookingsScreen extends StatelessWidget {
  final controller = Get.put(BookingsController());

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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 سهم الرجوع + العنوان
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "My Booking",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A3C9A),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 تفاصيل الحجز + التقييم
              Expanded(
                child: Obx(() {
                  if (controller.bookingId.isEmpty) {
                    return const Center(
                        child: Text(
                          "No booking found",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ));
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Event: ${controller.eventName.value}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Company: ${controller.companyName.value}"),
                        Text("Venue: ${controller.venueName.value}"),
                        Text("Services: ${controller.services.join(', ')}"),
                        Text(
                            "Total: \$${controller.totalPrice.value.toStringAsFixed(2)}"),
                        Text("Status: ${controller.status.value}",
                            style: const TextStyle(color: Colors.green)),

                        const SizedBox(height: 20),
                        const Text("Rate your booking:",
                            style: TextStyle(fontSize: 16)),
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                index < controller.rating.value
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                              ),
                              onPressed: () =>
                                  controller.setRating(index + 1),
                            );
                          }),
                        ),

                        ElevatedButton(
                          onPressed: controller.submitRating,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A3C9A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: const Text("Submit Rating"),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
