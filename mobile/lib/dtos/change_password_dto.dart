class ChangePasswordDTO {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordDTO(
      {required this.currentPassword,
      required this.newPassword,
      required this.confirmPassword});

  Map<String, dynamic> toJson() => {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };
}
