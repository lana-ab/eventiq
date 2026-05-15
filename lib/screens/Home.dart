/*
//import 'package:flutter/material.dart';
//import 'package:get/get.dart';
//import 'package:carousel_slider/carousel_slider.dart';
//import 'package:untitled2/screens/CompanyCard.dart';
//import 'package:untitled21/view/screens/company.dart';
//import '../../logic/controller/companyController.dart';
//import '../widgets/companyCard.dart';


//class Home extends StatelessWidget {
  class CompanyModel {
  final int companyId;
  final String companyName;
  final String companyImg;
  final double averageRating;
  final String description;

  CompanyModel({
  required this.companyId,
  required this.companyName,
  required this.companyImg,
  required this.averageRating,
  required this.description,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
  return CompanyModel(
  companyId: json['id'],
  companyName: json['company_name'] ?? 'No companyName',
  companyImg: json['company_image'] ?? 'No companyImg',
  description: json['description'] ?? 'No Description',
  averageRating: (json['average_rating'] ?? 0).toDouble(),
  );
  }
  }

  const Home({super.key});

  final String baseUrl = 'http://192.168.1.104:8000/storage';

  @override
  Widget build(BuildContext context) {
    final CompanyController controller = Get.find();

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
    child: Column(
    children: [
    // Header
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
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

    // Banner Image
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
    'images/photo1.png',//هي صورة الاعلان
    fit: BoxFit.cover,
    width: double.infinity,
    ),
    ),
    ],
    ),
    ),

    // Section Title + Button
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Row(
    children: [
    const Text(
    "Companies",
    style: TextStyle(fontSize: 20, color: Color(0xFF4A3C9A),decoration: TextDecoration.none,),
    ),
    const Spacer(),
    TextButton(
    onPressed: () {
    Get.to(() =>  Company());//الانتقال الى صفحة الشركات
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
            return const Center(child: Text("No companies available",style:TextStyle(color: Colors.grey,fontSize:14,decoration: TextDecoration.none )));
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
                imageUrl: '$baseUrl/${company.companyImg}',
                rating: company.averageRating,
              );
            }).toList(),
          );
        }),
      ),
    ],
    ),
    ),
        ],
    );
  }
}
*/