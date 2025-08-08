import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/auth/usecases/forgot_pass_otp.dart';
import '../../../service_locator.dart';
import 'forgot_pass_otp_state.dart';

class ForgotPassOtpCubit extends Cubit<ForgotPassOtpState> {
  ForgotPassOtpCubit() : super(ForgotPassOtpInitial());

  Future<void> sendOtp(String email) async {
    emit(ForgotPassOtpLoading());

    try {
      final result = await sl<ForgotPassOtpUseCase>().call(params: email);

      result.fold(
        (error) {
          emit(ForgotPassOtpFailure(error: error.toString()));
        },
        (success) {
          emit(ForgotPassOtpSuccess(message: 'Mã OTP đã được gửi đến email của bạn!'));
        },
      );
    } catch (e) {
      emit(ForgotPassOtpFailure(error: e.toString()));
    }
  }
}
