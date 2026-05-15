import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/BookingController.dart';

class CreateBookingScreen extends StatelessWidget {
  final BookingController controller = Get.put(BookingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 🔙 زر الرجوع
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.black),
                                onPressed: () => Get.back(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // صورة
                          Image.asset(
                            'assets/ChatGPT_Image_Jun_22__2025__12_00_56_PM-removebg-preview.png',
                            height: 200,
                            width: 250,
                          ),
                          const SizedBox(height: 38),

                          // العنوان
                          Text(
                            'Create Booking',
                            style: const TextStyle(
                              color: Color(0xFF4A3C9A),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Fill in the details to schedule your event',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),

                          // الكارد
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 35,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  // حقل التاريخ
                                  TextFormField(
                                    controller: controller.dateController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: 'Select date',
                                      prefixIcon: const Icon(Icons.calendar_today,
                                          color: Color(0xFF4A3C9A)),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                    ),
    onTap: () async { DateTime? pickedDate = await showDatePicker( context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100), ); if (pickedDate != null) { TimeOfDay? pickedTime = await showTimePicker( context: context, initialTime: TimeOfDay.now(), ); if (pickedTime != null) { final combined = DateTime( pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute, ); controller.setDate(combined); } } },
                                  ),
                                  const SizedBox(height: 20),

                                  // عدد المدعوين
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'Number of invites',
                                      prefixIcon: const Icon(Icons.group, color: Color(0xFF4A3C9A)),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 18),
                                    ),
                                    onChanged: (value) => controller.invitesCount.value =
                                        int.tryParse(value) ?? 0,
                                  ),
                                  const SizedBox(height: 30),

                                  // زر المتابعة
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () => controller.createBooking(),
                                      icon: const Icon(Icons.arrow_forward),
                                      label: const Text('Continue'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF7C69C1),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
