class UserFacePhotoModel {
  int id;
  String fileName;
  DateTime uploadDate;

  UserFacePhotoModel({
    required this.id,
    required this.fileName,
    required this.uploadDate,
  });

  factory UserFacePhotoModel.fromJson(Map<String, dynamic> json) {
    return UserFacePhotoModel(
      id: json['id'],
      fileName: json['fileName'],
      uploadDate: DateTime.parse(json['uploadDate']),
      // filePath: json['filePath'],
    );
  }
}
