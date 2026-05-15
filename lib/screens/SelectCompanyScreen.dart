import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/company_controller.dart';

class SelectCompanyScreen extends StatelessWidget {
  final CompanyController controller = Get.put(CompanyController());

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
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Text(
                  'select company',
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
                  } else if (controller.companies.isEmpty) {
                    return const Center(
                      child: Text(
                        'no company found!ً',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: controller.companies.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final company = controller.companies[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: const Icon(Icons.business, color: Color(0xFF4A3C9A)),
                            title: Text(
                              company['name'] ?? 'اسم غير متوفر',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF4A3C9A),
                              ),
                            ),
                            subtitle: Text(
                              company['description'] ?? '',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            onTap: () {
                              print("تم اختيار شركة ID: ${company['id']}");
                              // يمكنك الانتقال لواجهة الخدمات هنا
                            },
                          ),
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
