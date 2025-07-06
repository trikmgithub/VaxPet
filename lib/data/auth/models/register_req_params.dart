class RegisterReqParams {
  final String email;
  final String password;

  RegisterReqParams({required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }
}
