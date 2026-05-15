import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';
import '../services/api_constants.dart';
import 'package:flutter/material.dart';
import 'BookingController.dart';


class CustomBookingController extends GetxController {
  var events = <Map<String, dynamic>>[].obs;
  var companies = <Map<String, dynamic>>[].obs;
  var venues = <Map<String, dynamic>>[].obs;

  var selectedEventId = Rxn<int>();
  var selectedCompanyId = Rxn<int>();
  var selectedVenueId = Rxn<int>();
  var selectedCompanyEventId = Rxn<int>();

  var selectedEventName = ''.obs;
  var selectedVenueName = ''.obs;

  var bookingId = ''.obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    printToken();

    // ✅ استرجاع bookingId من BookingController
    try {
      final bookingController = Get.find<BookingController>();
      bookingId.value = bookingController.bookingId.value;
      print("🎫 bookingId received: ${bookingId.value}");
    } catch (e) {
      print("⚠️ BookingController not found: $e");
    }

    fetchAllData();
  }

  void printToken() async {
    final token = await AuthService.getToken();
    print("📢 User Token: $token");
  }

  void selectEvent(int id, String name) async {
    selectedEventId.value = id;
    selectedEventName.value = name;

    try {
      final token = await AuthService.getToken();
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/selectEvent?event_id=$id&booking_id=${bookingId.value}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("✅ Event selected successfully");
      } else {
        print("❌ Failed to select event: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error selecting event: $e");
    }
  }

  void selectCompany(int id) async {
    final selectedEventIdValue = selectedEventId.value;

    if (selectedEventIdValue == null) {
      Get.snackbar("Error", "Please select an event first",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      final token = await AuthService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/showProviders?event_id=$selectedEventIdValue'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final matched = (data as List).firstWhereOrNull((item) => item['company_id'] == id);

        if (matched == null) {
          Get.snackbar("Invalid", "This company is not linked with the selected event",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          return;
        }

        selectedCompanyId.value = id;
        selectedCompanyEventId.value = matched['company_events_id'];

        // ✅ Select company in backend
        final response2 = await http.post(
          Uri.parse('${ApiConstants.baseUrl}/selectProvider?booking_id=${bookingId.value}&company_id=$id'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response2.statusCode == 200) {
          print("✅ Company selected successfully");
        } else {
          print("❌ Failed to select company: ${response2.statusCode}");
        }

        await fetchVenues();
      } else {
        Get.snackbar("Error", "Failed to verify company-event relation",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void selectVenue(int id, String name) async {
    selectedVenueId.value = id;
    selectedVenueName.value = name;

    try {
      final token = await AuthService.getToken();
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/selectVenue?venue_id=$id&booking_id=${bookingId.value}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("✅ Venue selected successfully");
      } else {
        print("❌ Failed to select venue: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error selecting venue: $e");
    }
  }

  Future<void> fetchAllData() async {
    isLoading.value = true;
    await Future.wait([
      fetchEvents(),
      fetchCompanies(),
    ]);
    isLoading.value = false;
  }

  Future<void> fetchEvents() async {
    try {
      final token = await AuthService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/showEvents'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        events.value = data is List
            ? List<Map<String, dynamic>>.from(data)
            : List<Map<String, dynamic>>.from(data['events'] ?? []);
      } else {
        print("Error fetching events: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  Future<void> fetchCompanies() async {
    try {
      final token = await AuthService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/companies'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        companies.value = data is List
            ? List<Map<String, dynamic>>.from(data)
            : List<Map<String, dynamic>>.from(data['companies'] ?? []);
      } else {
        print("Error fetching companies: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching companies: $e");
    }
  }

  Future<void> fetchVenues({String? selectVenueName}) async {
    try {
      final token = await AuthService.getToken();
      final companyId = selectedCompanyId.value;

      if (companyId == null) {
        print("No company selected");
        venues.value = [];
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/showVenue?company_id=$companyId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          venues.value = List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data.containsKey('venues')) {
          venues.value = List<Map<String, dynamic>>.from(data['venues']);
        } else {
          venues.value = [];
        }
      } else {
        print("Error fetching venues: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception fetching venues: $e");
    }
  }

  Future<void> addVenue(String venueName) async {
    if (venueName.isEmpty) return;

    try {
      isLoading.value = true;
      final token = await AuthService.getToken();

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/venues'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': venueName}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Venue added successfully", snackPosition: SnackPosition.BOTTOM);
        await fetchVenues(selectVenueName: venueName);
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar("Error", data['message'] ?? "Failed to add venue", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void confirmBooking() {
    Get.toNamed('/select-services');
  }
}
