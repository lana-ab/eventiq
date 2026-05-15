import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:untitled2/profile/ProfileModel.dart';
import 'package:untitled2/services/auth_service.dart';
import '../helper/api.dart';
import 'package:untitled2/services/api_constants.dart';

class GetProfile {
  final Api _api = Api();

  Future<ProfileModel?> getProfile({required String token}) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("No token found!");
    var url = ApiConstants.profile;

    try {
      final response = await _api.get(url: url, token: token);
      print(" API Response: $response");
      return ProfileModel.fromJson(response);
    } catch (e) {
      print("Error in getProfile: $e");
      final error = e.toString().toLowerCase();

      if (error.contains('404') ||
          error.contains('not found') ||
          error.contains('no query results')) {
        return null;
      }

      rethrow;
  }
  }

  Future<void> addProfileInfo({
    required String token,
    required Map<String, String> data,
  }) async {
    var url = ApiConstants.profile;

    await _api.post(
      url: url,
      body: data,
      token: token,
    );
  }


  Future<void> updatePhoneAndBirth({
    required String token,
    required int id,
    required String phone,
    required String birthDate,
  }) async {
    final url = ApiConstants.profileById(id);

    final data = {
      'phone': phone,
      'birthDate': birthDate,
    };

    await _api.patch(
      url: url,
      body: data,
      token: token,
    );
  }


  Future<String?> updateImageOnly({
    required String token,
    required int id,
    required File imageFile,
  }) async {
    final url = Uri.parse(ApiConstants.profileById(id));

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.files.add(await http.MultipartFile.fromPath('img', imageFile.path));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = jsonDecode(respStr);
        print("Image Updated: $data");
        return data['company']['img'];
      } else {
        print(' Failed to update image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(" Error in updateImageOnly: $e");
      return null;
    }
  }



}