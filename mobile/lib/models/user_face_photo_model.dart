class UserFacePhotoModel {
  int id;
  String fileName;
  DateTime createdAt;
  DateTime? updatedAt;

  UserFacePhotoModel({
    required this.id,
    required this.fileName,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserFacePhotoModel.fromJson(Map<String, dynamic> json) {
    return UserFacePhotoModel(
      id: json['id'],
      fileName: json['fileName'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
