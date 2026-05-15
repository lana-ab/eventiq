import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:untitled2/screens/Company.dart';
import 'package:untitled2/services/api_constants.dart';
import 'package:untitled2/search/search_controller.dart';
class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController searchTextController = TextEditingController();
  final searchController = Get.put(CompanySearchController ());


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDEBFA), Color(0xFFBCAEF3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            TextField(
              controller: searchTextController,
              decoration: InputDecoration(
                hintText: 'Search for companies',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                searchController.search(value);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (searchController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (searchTextController.text.isEmpty) {
                  return _buildAnimatedSearchIcon();
                }

                if (searchController.searchResults.isEmpty) {
                  return const Center(child: Text("No results found."));
                }

                return GridView.builder(
                  itemCount: searchController.searchResults.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final company = searchController.searchResults[index];
                    return Company1Card(
                      companyImg: '${ApiConstants.imageBaseUrl}${company.companyImg}', // ✅
                      name: company.companyName,
                      description: company.description,
                      companyId: company.companyId,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSearchIcon() {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          final angle = sin(_controller.value * 2 * pi) * 0.2;
          final opacity = 0.7 + (sin(_controller.value * 2 * pi) * 0.3);

          return Opacity(
            opacity: opacity,
            child: Transform.rotate(
              angle: angle,
              child: child,
            ),
          );
        },
        child: const Icon(
          Icons.search,
          size: 80,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}
