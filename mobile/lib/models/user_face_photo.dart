class UserFacePhoto {
  late int id;
  late String file;
  late String fileName;
  late DateTime uploadDate;
  late String filePath;

  UserFacePhoto({
    required this.id,
    required this.file,
    required this.fileName,
    required this.uploadDate,
    required this.filePath,
  });

  factory UserFacePhoto.fromJson(Map<String, dynamic> json) {
    return UserFacePhoto(
      id: json['id'] as int,
      file: json['file'],
      fileName: json['fileName'],
      uploadDate: DateTime.parse(json['uploadDate']),
      filePath: json['filePath'],
    );
  }
}
