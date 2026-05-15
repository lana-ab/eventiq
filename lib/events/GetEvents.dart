import '../helper/api.dart';
import 'package:untitled2/events/eventsModel.dart';
import 'package:untitled2/services/api_constants.dart';

class GetEvents {
  Future<List<EventsModel>> getEvents({
    required String token,
    required int companyId,
  }) async {
    final response = await Api().get(
      url: "${ApiConstants.baseUrl}/companies/$companyId/events",
      token: token,
    );

    List<dynamic> data = response['events'];

    return data.map((e) => EventsModel.fromJson(e)).toList();
  }
}