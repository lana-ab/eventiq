/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/event_controller.dart';

class CreateEventScreen extends StatelessWidget {
  final EventController controller = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEDEBFA), Color(0xFFBCAEF3)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 30),
                    Center(
                      child: Text(
                        'Create Event',
                        style: TextStyle(
                          color: Color(0xFF6A4BBC),
                          fontSize: 43,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // التاريخ والوقت
                    TextFormField(
                      readOnly: true,
                      controller: controller.dateController,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate.value ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(controller.selectedDate.value ?? DateTime.now()),
                          );

                          if (pickedTime != null) {
                            final combinedDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            controller.setDate(combinedDateTime);
                          }
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Select date & time',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // عدد المدعوين
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter number of invites',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        controller.numberOfInvites.value = int.tryParse(value) ?? 0;
                      },
                    ),

                    const SizedBox(height: 20),

                    // الموقع
                    Obx(() => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      hint: const Text('Select location', style: TextStyle(color: Colors.grey)),
                      value: controller.selectedLocation.value.isEmpty ? null : controller.selectedLocation.value,
                      items: controller.availableLocations.map((location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) controller.selectedLocation.value = value;
                      },
                    )),
                    TextButton(
                      onPressed: () {
                        Get.defaultDialog(
                          title: 'Add a new location',
                          content: TextField(
                            onSubmitted: (value) {
                              controller.addCustomLocation(value);
                              Get.back();
                            },
                            decoration: const InputDecoration(hintText: 'Enter new location'),
                          ),
                        );
                      },
                      child: const Text('Add a new location +', style: TextStyle(color: Colors.black54)),
                    ),

                    const SizedBox(height: 20),

                    // نوع الفعالية
                    const Text('Event type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6A4BBC))),
                    const SizedBox(height: 8),
                    Obx(() => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      hint: const Text('Select type', style: TextStyle(color: Colors.grey)),
                      value: controller.selectedEventType.value.isEmpty ? null : controller.selectedEventType.value,
                      items: controller.availableEventTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) controller.selectedEventType.value = value;
                      },
                    )),

                    const SizedBox(height: 20),

                    // الشركة المنظمة
                    const Text('Companies', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6A4BBC))),
                    const SizedBox(height: 8),
                    Obx(() => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      hint: const Text('Select company', style: TextStyle(color: Colors.grey)),
                      value: controller.selectedCompany.value.isEmpty ? null : controller.selectedCompany.value,
                      items: controller.availableCompanies.map((company) {
                        return DropdownMenuItem<String>(
                          value: company,
                          child: Text(company),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) controller.selectedCompany.value = value;
                      },
                    )),

                    const SizedBox(height: 45),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A4BBC),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        controller.createBooking(); // هنا تربط بالـ API لاحقًا
                      },
                      child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 26)),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF6A4BBC)),
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/