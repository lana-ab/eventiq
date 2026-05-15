import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/custom_booking_controller.dart';
import 'package:collection/collection.dart';
import 'ServiceSelectionScreen.dart';
import 'UnifiedServicesScreen.dart';




class CustomBookingScreen extends StatelessWidget {
  final controller = Get.put(CustomBookingController());

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
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
                  onPressed: () => Get.back(),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Book Your Event Now",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A3F7A),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                /// Event Dropdown
                Obx(() {
                  return DropdownButtonFormField<int>(
                    decoration: _inputDecoration('Select Event'),
                    value: controller.selectedEventId.value,
                    items: controller.events.map((event) {
                      return DropdownMenuItem<int>(
                        value: event['id'],
                        child: Text(event['event_name'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        final selected = controller.events.firstWhere((e) => e['id'] == val);
                        controller.selectEvent(val, selected['event_name']);
                      }
                    },

                  );
                }),

                const SizedBox(height: 30),

                /// Company Dropdown
                Obx(() {
                  return DropdownButtonFormField<int>(
                    decoration: _inputDecoration('Select Company'),
                    value: controller.selectedCompanyId.value,
                    items: controller.companies.map((company) {
                      return DropdownMenuItem<int>(
                        value: company['id'],
                        child: Text(company['company_name'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) controller.selectCompany(val);
                    },
                  );
                }),

                const SizedBox(height: 30),

                /// Venue Dropdown
                Obx(() {
                  return DropdownButtonFormField<int>(
                    decoration: _inputDecoration('Select Venue'),
                    value: controller.selectedVenueId.value,
                    items: controller.venues.map((venue) {
                      return DropdownMenuItem<int>(
                        value: venue['id'],
                        child: Text(venue['venue_name'] ?? ''),

                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        final selected = controller.venues.firstWhere((v) => v['id'] == val);
                        controller.selectVenue(val, selected['venue_name']);
                      }
                    },

                  );
                }),

                const SizedBox(height: 22),

                ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Add New Venue', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7C69C1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 17),
                  ),
                  onPressed: () {
                    _showAddVenueDialog(context);
                  },
                ),

                const SizedBox(height: 90),
                ElevatedButton(
                  onPressed: () {
                    if (controller.selectedEventId.value == null) {
                      Get.snackbar("Error", "Please select an event first",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white);
                      return;
                    }
                    if (controller.selectedCompanyId.value == null) {
                      Get.snackbar("Error", "Please select a company first",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white);
                      return;
                    }
                    if (controller.selectedVenueId.value == null) {
                      Get.snackbar("Error", "Please select a venue first",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white);
                      return;
                    }

                    // الانتقال إلى شاشة الخدمات
                    Get.to(() => UnifiedServicesScreen(
                      bookingId: controller.bookingId.value,
                      eventName: controller.selectedEventName.value,
                      venueName: controller.selectedVenueName.value,
                      companyEventsId: controller.selectedCompanyEventId.value!,
                    ));

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C69C1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Center(
                    child: Text(
                      'Continue to Services',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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

  void _showAddVenueDialog(BuildContext context) {
    final TextEditingController venueController = TextEditingController();

    Get.defaultDialog(
      title: "Add New Venue",
      content: Column(
        children: [
          TextField(
            controller: venueController,
            decoration: const InputDecoration(
              labelText: "Venue Name",
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final name = venueController.text.trim();
              if (name.isNotEmpty) {
                Get.find<CustomBookingController>().addVenue(name);
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C69C1),
            ),
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }
}