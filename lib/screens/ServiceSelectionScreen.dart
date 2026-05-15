import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ServiceSelectionController.dart';

class ServiceSelectionScreen extends StatelessWidget {
  final int companyEventsId;

  // ✅ مررنا الـ ID هنا
  ServiceSelectionScreen({required this.companyEventsId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ تمرير القيمة للكونترولر عند الإنشاء
    final ServiceSelectionController controller =
    Get.put(ServiceSelectionController(companyEventsId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Services'),
        backgroundColor: const Color(0xFF4A3C9A),
        foregroundColor: Colors.white,
      ),
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
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.services.isEmpty) {
              return const Center(child: Text("No services found"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.services.length,
              itemBuilder: (context, index) {
                final service = controller.services[index];
                final quantity = controller.quantities[service['id']] ?? 1;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service['name'] ?? 'Unnamed Service',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF4A3C9A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(service['description'] ?? ''),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text("Quantity: ", style: TextStyle(fontWeight: FontWeight.w600)),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => controller.decreaseQuantity(service['id']),
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => controller.increaseQuantity(service['id']),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                controller.selectService(service['id']);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7C69C1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text("Select"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
