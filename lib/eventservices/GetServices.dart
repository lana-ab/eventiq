import '../helper/api.dart';
import 'package:untitled2/eventservices/serviceModel.dart';
import 'package:untitled2/services/api_constants.dart';

class GetServices {
  Future<List<ServiceModel>> getServices({
    required String token,
    int? companyEventsId,
  }) async {
    final String url = companyEventsId != null
        ? ApiConstants.getServicesByEvent(companyEventsId)
        : ApiConstants.showServices;

    final response = await Api().get(
      url: url,
      token: token,
    );

    List<dynamic> data = response;
    return data.map((e) => ServiceModel.fromJson(e)).toList();
  }

  Future<String> getServiceImage({
    required String token,
    required int serviceId,
  }) async {
    final response = await Api().get(
      url: ApiConstants.getServiceImage(serviceId),
      token: token,
    );

    if (response is Map &&
        response.containsKey('images') &&
        response['images'] is List &&
        response['images'].isNotEmpty) {
      return response['images'][0]['image_url'];
    }

    return '';
  }
}
