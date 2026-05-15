import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/home/CompanyModel.dart';

import 'package:untitled2/home/getCompany.dart';
import 'package:untitled2/services/api_constants.dart';

import '../services/auth_service.dart';

class HomeCompanyController extends GetxController {
  var companyList = <CompanyModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getCompanies();
  }

  Future<void> getCompanies() async {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AuthService.tokenKey) ?? '';

      print("🔑 Token used in HomeCompanyController: $token");

      if (token.isEmpty) {
        throw Exception("Token not found. Please login again.");
      }

      var companies = await GetCompanyService ().getCompanies(token: token);

      if (companies.isNotEmpty) {
        companyList.assignAll(companies);
      } else {
        Get.snackbar("Info", "No companies found",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error in getCompanies: $e");
      Get.snackbar("Error", "Failed to load companies: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  void searchCompanies(String query) async {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      var companies = await GetCompanyService ().getCompanies(token: token);

      if (query.isNotEmpty) {
        companies = companies
            .where((company) =>
            company.companyName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      companyList.assignAll(companies);
    } catch (e) {
      print("Error in searchCompanies: $e");
      Get.snackbar("Error", "Failed to search companies: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }
}
