class VerifyOtpReqParams {
  final String email;
  final String otp;

  VerifyOtpReqParams({required this.email, required this.otp});

  Map<String, dynamic> toMap() {
    return {'email': email, 'otp': otp};
  }
}
