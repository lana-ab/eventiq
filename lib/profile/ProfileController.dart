import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/profile/GetProfile.dart';

import 'package:untitled2/profile/ProfileModel.dart';



class ProfileController extends GetxController {
  var isLoading = true.obs;
  var profile = Rxn<ProfileModel>();
  var name = ''.obs;
  var email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadProfile();
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    name.value = prefs.getString('name') ?? '';
    email.value = prefs.getString('email') ?? '';
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final token = await _getToken();

      final result = await GetProfile().getProfile(token: token);


      final prefs = await SharedPreferences.getInstance();
      final localImagePath = prefs.getString('local_profile_image_path');

      if (localImagePath != null && localImagePath.isNotEmpty && File(localImagePath).existsSync()) {
        result?.img = localImagePath;
      }

      profile.value = result;


      if (result != null) {
        if ((result.name != null && result.name!.isNotEmpty) && name.value != result.name) {
          name.value = result.name!;
          await prefs.setString('name', result.name!);
        }
        if ((result.email != null && result.email!.isNotEmpty) && email.value != result.email) {
          email.value = result.email!;
          await prefs.setString('email', result.email!);
        }
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحميل البيانات");
    }
    isLoading.value = false;
  }

  Future<bool> addInfo(Map<String, String> data) async {
    try {
      final token = await _getToken();
      await GetProfile().addProfileInfo(token: token, data: data);
      await loadProfile();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateInfo({
    String? phone,
    String? birthDate,
    File? imageFile,
  }) async {
    try {
      final token = await _getToken();
      final id = profile.value?.id;
      if (id == null) throw Exception("Profile ID not found");

      if (imageFile != null) {
        final imageUrl = await GetProfile().updateImageOnly(token: token, id: id, imageFile: imageFile);
        if (imageUrl == null) throw Exception("failed");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('local_profile_image_path', imageFile.path);
      }

      if (phone != null || birthDate != null) {
        await GetProfile().updatePhoneAndBirth(
          token: token,
          id: id,
          phone: phone ?? profile.value?.phone ?? '',
          birthDate: birthDate ?? profile.value?.birthDate ?? '',
        );
      }

      await loadProfile();
      return true;
    } catch (e) {
      print(" Error in updateInfo: $e");
      return false;
    }
  }
}