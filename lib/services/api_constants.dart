class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const String imageBaseUrl = 'http://10.0.2.2:8000/storage/';

  static const String login = '$baseUrl/login';
  static const String signup = '$baseUrl/register';
  static const String verifyOtp = '$baseUrl/verify-email';
  static const String forgotPass = '$baseUrl/forgot-password';
  static const String sendVerificationCode = '$baseUrl/send-verification-code';
  static const String verifyCode = '$baseUrl/verify-verification-code';
  static const String createBooking = '$baseUrl/createBooking';
  static const String payment = '$baseUrl/payment';

  static const String showServices = '$baseUrl/showServices';
  static const String servicesGetImage = '$baseUrl/servicesGetImage';


  static const String selectService = '$baseUrl/selectService';
  static const String deleteServiceBooking = '$baseUrl/deleteServiceBooking';

  static const String getCompanies = '$baseUrl/companies';
  static const String searchCompanies = '$baseUrl/company/search';
  static String getCompanyEvents(int companyId) =>
      '$baseUrl/companies/$companyId/events';
  static String getServicesByEvent(int eventId) =>
      '$baseUrl/showServices?company_events_id=$eventId';

  static String getServiceImage(int serviceId) =>
      '$baseUrl/servicesGetImage/?service_id=$serviceId';
  static const String profile = "$baseUrl/profiles";
  static String updateProfile(int id) => "$baseUrl/profile/$id";
  static String profileById(int id) {
    return "$baseUrl/profile/$id";}
  static const String addRating = "$baseUrl/ratings";
  static String getCompanyRating(int companyId) =>
      "$baseUrl/companies/$companyId/rating";
}
