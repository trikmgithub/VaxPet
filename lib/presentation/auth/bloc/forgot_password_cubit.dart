import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/auth/usecases/forgot_password.dart';
import '../../../service_locator.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(ForgotPasswordLoading());

    try {
      final result = await sl<ForgotPasswordUseCase>().call(
        params: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        },
      );

      result.fold(
        (error) {
          emit(ForgotPasswordFailure(error: error.toString()));
        },
        (success) {
          emit(ForgotPasswordSuccess(message: 'Đổi mật khẩu thành công!'));
        },
      );
    } catch (e) {
      emit(ForgotPasswordFailure(error: e.toString()));
    }
  }
}
