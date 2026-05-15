import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/profile/profileController.dart';
import 'profileImage.dart';
import 'profileInfoCard.dart';
import 'package:untitled2/profile/EditProfileScreen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final ProfileController controller = Get.put(ProfileController());

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
    child: SizedBox.expand(
    child: Obx(() {

    if (controller.isLoading.value) {
    return const Center(child: CircularProgressIndicator());
    }
    final profile = controller.profile.value;

    if (profile == null) {
    return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
    children: [
    const SizedBox(height: 16),
    const CircleAvatar(
    radius: 120,
    backgroundColor: Colors.grey,
    child: Icon(Icons.person, size: 50, color: Colors.white),
    ),
    const SizedBox(height: 16),
    Text(
    controller.name.value,
    style: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    ),
    ),
    Text(
    controller.email.value,
    style: const TextStyle(fontSize: 14, color: Colors.grey),
    ),
    const SizedBox(height: 24),
    const Center(child: Text("no data for profile")),
    ],
    ),
    );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 16),
          ProfileImage(imageUrl: profile.img),
          const SizedBox(height: 16),
          Text(
            controller.name.value.isNotEmpty
                ? controller.name.value
                : (profile.name ?? ''),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            controller.email.value.isNotEmpty
                ? controller.email.value
                : (profile.email ?? ''),
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Column(
              children: [
                ProfileInfoCard(
                  icon: Icons.phone,
                  label: 'Phone Number',
                  value: profile.phone,
                ),
                ProfileInfoCard(
                  icon: Icons.cake,
                  label: 'Birth Date',
                  value: profile.birthDate,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Edit Info"),
                  onTap: () async {
                    await Get.to(() => const EditProfileScreen());
                    controller.loadProfile();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text("Change Language"),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Log out"),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
    }),
    ),
    ),
        ),
    );
  }
}