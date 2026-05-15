import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:untitled2/events/EventsScreen.dart';
import 'package:untitled2/home/HomeCompanyController.dart';
import 'package:untitled2/screens/Company.dart';
import 'package:untitled2/screens/CompanyCard.dart';

import 'package:untitled2/services/api_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeCompanyController controller = Get.put(HomeCompanyController());

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEDEBFA), Color(0xFFBCAEF3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: const [
                      Text(
                        "Check our latest\nEvents",
                        style: TextStyle(
                          fontSize: 23,
                          color: Color(0xFF4A3C9A),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.notifications, color: Color(0xFFBCAEF3), size: 28),
                    ],
                  ),
                ),

                // Banner
                SizedBox(
                  height: 230,
                  child: PageView(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white.withOpacity(0.3),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/decorated-seatings-wedding-guests.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ),

                // Section title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      const Text(
                        "Companies",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF4A3C9A),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const Company());
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.4),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "All",
                          style: TextStyle(fontSize: 16, color: Color(0xFF4A3C9A)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.companyList.isEmpty) {
                      return const Center(
                        child: Text(
                          "No companies available",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      );
                    }

                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 320,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.7,
                      ),
                      items: controller.companyList.map((company) {
                        return CompanyCard(
                          name: company.companyName,
                          imageUrl: '${ApiConstants.imageBaseUrl}${company.companyImg}',
                          rating: company.averageRating,
                          onTap: () {
                            // 👈 الانتقال لشاشة الفعاليات
                            Get.to(() => EventsScreen(companyId: company.companyId));
                          },
                        );
                      }).toList(),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
