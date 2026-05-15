class ServiceModel {
  final int serviceId;
  final String serviceName;
  final String serviceDescription;
  final double servicePrice;
  final int serviceQuantity;
  final String? image;

  ServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.serviceDescription,
    required this.servicePrice,
    required this.serviceQuantity,
    this.image,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceId: json['id'] ?? 0,
      serviceName: json['service_name'] ?? 'No Name',
      serviceDescription: json['service_description'] ?? 'No Description',
      servicePrice: double.tryParse(json['service_price'].toString()) ?? 0.0,
      serviceQuantity: (json['service_quantity'] ?? 0).toInt(),
      image: json['image'],
    );
  }

  ServiceModel copyWith({
    int? serviceId,
    String? serviceName,
    String? serviceDescription,
    double? servicePrice,
    int? serviceQuantity,
    String? image,
  }) {
    return ServiceModel(
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceDescription: serviceDescription ?? this.serviceDescription,
      servicePrice: servicePrice ?? this.servicePrice,
      serviceQuantity: serviceQuantity ?? this.serviceQuantity,
      image: image ?? this.image,
    );
  }
}