import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../domain/membership/usecases/get_membership_status.dart';
import '../../../service_locator.dart';
import 'membership_state.dart';

class MembershipCubit extends Cubit<MembershipState> {
  MembershipCubit() : super(MembershipLoading());

  void getMembershipStatus(int customerId) async {
    emit(MembershipLoading());

    try {
      print('Đang gọi API membership với customerId: $customerId');

      Either result = await sl<GetMembershipStatusUseCase>().call(
        params: customerId,
      );

      result.fold(
        (error) {
          print('Lỗi từ API membership: $error');
          emit(MembershipFailure(errorMessage: 'Không thể tải thông tin thành viên: ${error.toString()}'));
        },
        (data) {
          print('Dữ liệu nhận được từ API: $data');
          try {
            final membershipStatus = MembershipStatusResponse.fromJson(data);
            print('Parse JSON thành công');
            emit(MembershipLoaded(membershipStatus: membershipStatus));
          } catch (parseError) {
            print('Lỗi khi parse JSON: $parseError');
            emit(MembershipFailure(errorMessage: 'Lỗi xử lý dữ liệu: ${parseError.toString()}'));
          }
        },
      );
    } catch (e) {
      print('Exception trong getMembershipStatus: $e');
      emit(MembershipFailure(errorMessage: 'Đã xảy ra lỗi không mong muốn: ${e.toString()}'));
    }
  }
}
