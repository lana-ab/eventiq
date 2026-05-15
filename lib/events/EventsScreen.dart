import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/eventservices/EventServicesScreen.dart';
import 'package:untitled2/events/EventsController.dart';

class EventsScreen extends StatelessWidget {
  final int companyId;
  const EventsScreen({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventController(companyId: companyId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Events',
          style: TextStyle(
            color: Color(0xFF4A3C9A),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDEBFA), Color(0xFFBCAEF3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: kToolbarHeight + 20,
            left: 20,
            right: 20,
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.eventsList.isEmpty) {
              return const Center(child: Text("No events available."));
            }

            return ListView.separated(
              itemCount: controller.eventsList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final event = controller.eventsList[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Get.to(() => Services(eventId: event.id));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF4A3C9A),
                        fontWeight: FontWeight.w600,
                      ),
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