class UserFacePhotoModel {
  int id;
  String fileName;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserFacePhotoModel({
    required this.id,
    required this.fileName,
    this.createdAt,
    this.updatedAt,
  });

  factory UserFacePhotoModel.fromJson(Map<String, dynamic> json) {
    return UserFacePhotoModel(
      id: json['id'],
      fileName: json['fileName'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
