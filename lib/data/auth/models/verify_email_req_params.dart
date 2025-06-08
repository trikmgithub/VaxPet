class VerifyEmailReqParams {
  final String email;
  final String otp;

  VerifyEmailReqParams({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}