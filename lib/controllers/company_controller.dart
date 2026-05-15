import 'package:get/get.dart';
import '../services/company_service.dart';

class CompanyController extends GetxController {
  var isLoading = true.obs;
  var companies = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadCompanies();
  }

  Future<void> loadCompanies() async {
    try {
      isLoading.value = true;
      final result = await CompanyService.fetchCompanies();
      companies.assignAll(result);
    } catch (e) {
      print("خطأ أثناء جلب الشركات: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
