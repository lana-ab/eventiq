class CompanyModel {
  final int companyId;
  final String companyName;
  final String companyImg;
  final double averageRating;
  final String description;

  CompanyModel({
    required this.companyId,
    required this.companyName,
    required this.companyImg,
    required this.averageRating,
    required this.description,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      companyId: json['id'] ?? 0,
      companyName: json['company_name']?.toString() ?? 'No companyName',
      companyImg: json['company_image']?.toString() ?? '',
      description: json['description']?.toString() ?? 'No Description',
      averageRating: (json['average_rating'] ?? 0).toDouble(),
    );
  }
}