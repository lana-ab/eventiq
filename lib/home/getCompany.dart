import '../helper/api.dart'; // استدعاء ملف الـ API
import '../services/api_constants.dart'; // استدعاء ثابتات الروابط
import 'CompanyModel.dart'; // استدعاء موديل الشركة

class GetCompanyService {
  Future<List<CompanyModel>> getCompanies({required String token}) async {
    final response = await Api().get(
      url: ApiConstants.getCompanies,
      token: token,
    );

    List<dynamic> data = response;
    return data.map((e) => CompanyModel.fromJson(e)).toList();
  }
}

