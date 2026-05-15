import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/home/HomeCompanyController.dart';

//import 'events.dart';

class Company extends StatelessWidget {
  const Company ({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeCompanyController>();
    const String baseUrl = 'http://192.168.1.104:8000/storage';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Companies',
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
            if (controller.companyList.isEmpty) {
              return const Center(child: Text('No companies available.'));
            }

            return GridView.builder(
              itemCount: controller.companyList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final company = controller.companyList[index];
                return Company1Card(
                  companyImg: '$baseUrl/${company.companyImg}',
                  name: company.companyName,
                  description: company.description,
                  companyId: company.companyId,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class Company1Card extends StatelessWidget {
  final String companyImg;
  final String name;
  final String description;
  final int companyId;

  const Company1Card({
    super.key,
    required this.companyImg,
    required this.name,
    required this.description,
    required this.companyId,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.5),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
       // onTap: () {
        //  Get.to(() => Events(companyId: companyId));
       // },
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(Uri.encodeFull(companyImg)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A3C9A),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}