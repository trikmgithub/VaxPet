abstract class ForgotPassOtpState {}

class ForgotPassOtpInitial extends ForgotPassOtpState {}

class ForgotPassOtpLoading extends ForgotPassOtpState {}

class ForgotPassOtpSuccess extends ForgotPassOtpState {
  final String message;

  ForgotPassOtpSuccess({required this.message});
}

class ForgotPassOtpFailure extends ForgotPassOtpState {
  final String error;

  ForgotPassOtpFailure({required this.error});
}
