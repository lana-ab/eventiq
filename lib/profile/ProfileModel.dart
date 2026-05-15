class ProfileModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? birthDate;
  String? img;

  ProfileModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.birthDate,
    this.img,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {

    return ProfileModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      birthDate: json['birthDate'],
      img: json['img'],
    );
  }
}