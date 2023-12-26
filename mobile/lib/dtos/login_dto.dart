class LoginDTO {
  late String email;
  late String password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
