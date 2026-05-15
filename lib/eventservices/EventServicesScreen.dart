// services_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/eventservices/ServiceCard.dart';
import 'package:untitled2/eventservices/serviceController.dart';
import 'package:untitled2/eventservices/serviceModel.dart';



class Services extends StatelessWidget {
  final int eventId;

  const Services({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final ServiceController controller = Get.put(ServiceController(eventId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Services',
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
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.servicesList.isEmpty) {
              return const Center(
                child: Text(
                  "No services available.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }

            return GridView.builder(
              itemCount: controller.servicesList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final ServiceModel service = controller.servicesList[index];
                return ServiceCard(service: service);
              },
            );
          }),
        ),
      ),
    );
  }
}