import 'package:get/get.dart';
import 'dart:async';
class Profile {
  int? id; // هذا مهم
  String? img;
  String? name;
  String? email;
  String? phone;
  String? birthDate;

  Profile({this.id, this.img, this.name, this.email, this.phone, this.birthDate});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'],
    img: json['img'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    birthDate: json['birthDate'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'img': img,
    'name': name,
    'email': email,
    'phone': phone,
    'birthDate': birthDate,
  };
}


class ProfileController extends GetxController {
  var profile = Rx<Profile?>(null);
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    profile.value = Profile(
      id: 1,
      img: '',
      name: 'lana',
      email: 'lana@gmail.com',
      phone: '0123456789',
      birthDate: '1999-01-01',
    );
    isLoading.value = false;
  }

  void updatePhone(String phone) {
    profile.update((val) {
      val?.phone = phone;
    });
  }

  void updateBirthDate(String birthDate) {
    profile.update((val) {
      val?.birthDate = birthDate;
    });
  }

  void updateImage(String imagePath) {
    profile.update((val) {
      val?.img = imagePath;
    });
  }

  Future<bool> saveProfile() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    return true;
  }
}