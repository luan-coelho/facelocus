class LoginRequest {
  String login;
  String password;

  LoginRequest(this.login, this.password);

  Map<String, dynamic> toJson() => {
        'login': login,
        'password': password,
      };
}
