import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/unified_services_controller.dart';
import 'SummaryScreen.dart';

class UnifiedServicesScreen extends StatelessWidget {
  final String bookingId;
  final String eventName;
  final String venueName;
  final int companyEventsId;

  const UnifiedServicesScreen({
    required this.bookingId,
    required this.eventName,
    required this.venueName,
    required this.companyEventsId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UnifiedServicesController());
    controller.setBookingId(bookingId, companyEventsId);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDEBFA), Color(0xFFBCAEF3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.services.isEmpty) {
              return const Center(child: Text("No services available"));
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF4A3C9A)),
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Select Services",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A3C9A),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    itemCount: controller.services.length,
                    itemBuilder: (context, index) {
                      final service = controller.services[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 16,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
                        color: const Color(0xFFF7F4FF),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFBCAEF3), width: 5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 160,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[200],
                                ),
                                child: service['image_url'] != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    service['image_url'],
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(child: CircularProgressIndicator());
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      print("🧨 Failed to load image: ${service['image_url']}");
                                      print("📛 Error details: $error");
                                      return const Icon(
                                        Icons.broken_image,
                                        size: 60,
                                        color: Colors.red,
                                      );
                                    },
                                  ),

                                )
                                    : const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 9),
                              Text(
                                service['service_name'] ?? 'Service Name',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4A3C9A),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                service['service_description'] ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Price: \$${service['service_price']}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),

                              // زر اختيار الخدمة فقط، بدون كمية
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Obx(() {
                                    final isSelected = controller.selectedServiceIds.contains(service['id']);

                                    return ElevatedButton(
                                      onPressed: () => controller.selectService(service['id']),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isSelected ? Colors.green : const Color(0xFF4A3C9A),
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: Text(
                                        isSelected ? "Selected" : "Select",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.selectedServices.isEmpty) {
                        Get.snackbar(
                          "No Services Selected",
                          "Please select at least one service.",
                        );
                        return;
                      }

                      Get.to(() => SummaryScreen(
                        selectedServices: controller.selectedServices,
                        eventName: eventName,
                        venueName: venueName,
                        bookingId: bookingId,
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A3C9A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}