import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/auth/usecases/change_password.dart';
import '../../../service_locator.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(const ChangePasswordState());

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // Validate input
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      emit(state.copyWith(
        status: ChangePasswordStatus.failure,
        errorMessage: 'Vui lòng điền đầy đủ thông tin',
      ));
      return;
    }

    if (newPassword != confirmPassword) {
      emit(state.copyWith(
        status: ChangePasswordStatus.failure,
        errorMessage: 'Mật khẩu mới và xác nhận mật khẩu không khớp',
      ));
      return;
    }

    if (newPassword.length < 6) {
      emit(state.copyWith(
        status: ChangePasswordStatus.failure,
        errorMessage: 'Mật khẩu mới phải có ít nhất 6 ký tự',
      ));
      return;
    }

    if (oldPassword == newPassword) {
      emit(state.copyWith(
        status: ChangePasswordStatus.failure,
        errorMessage: 'Mật khẩu mới phải khác mật khẩu cũ',
      ));
      return;
    }

    emit(state.copyWith(status: ChangePasswordStatus.loading));

    try {
      // Get email from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? email = prefs.getString('email');

      if (email == null) {
        emit(state.copyWith(
          status: ChangePasswordStatus.failure,
          errorMessage: 'Không tìm thấy thông tin người dùng',
        ));
        return;
      }

      // Call change password use case
      final result = await sl<ChangePasswordUseCase>().call(
        params: {
          'email': email,
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      result.fold(
        (failure) {
          emit(state.copyWith(
            status: ChangePasswordStatus.failure,
            errorMessage: failure.toString(),
          ));
        },
        (success) {
          emit(state.copyWith(
            status: ChangePasswordStatus.success,
            successMessage: 'Đổi mật khẩu thành công',
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: ChangePasswordStatus.failure,
        errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
      ));
    }
  }

  void reset() {
    emit(const ChangePasswordState());
  }
}
