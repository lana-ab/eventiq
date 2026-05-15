// screens/select_event_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/EventSelectionController.dart';

class SelectEventScreen extends StatelessWidget {
  final controller = Get.put(EventSelectionController());

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
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'select event',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3C9A),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.events.isEmpty) {
                    return const Center(
                      child: Text(
                        "لا توجد فعاليات حالياً",
                        style: TextStyle(color: Colors.black87),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.events.length,
                    itemBuilder: (context, index) {
                      final event = controller.events[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            event['name'] ?? 'فعالية بدون اسم',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF4A3C9A),
                            ),
                          ),
                          subtitle: Text(
                            event['description'] ?? '',
                            style: const TextStyle(color: Colors.black54),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              controller.selectEvent(event['id']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7C69C1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text("اختيار"),
                          ),
                        ),
                      );
                    },
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
