class UserFacePhotoModel {
  late int id;
  late String file;
  late String fileName;
  late DateTime uploadDate;
  late String filePath;

  UserFacePhotoModel({
    required this.id,
    required this.file,
    required this.fileName,
    required this.uploadDate,
    required this.filePath,
  });

  factory UserFacePhotoModel.fromJson(Map<String, dynamic> json) {
    return UserFacePhotoModel(
      id: json['id'] as int,
      file: json['file'],
      fileName: json['fileName'],
      uploadDate: DateTime.parse(json['uploadDate']),
      filePath: json['filePath'],
    );
  }
}
