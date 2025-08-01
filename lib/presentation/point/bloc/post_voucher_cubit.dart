import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../domain/voucher/usecases/post_voucher.dart';
import '../../../service_locator.dart';
import 'post_voucher_state.dart';

class PostVoucherCubit extends Cubit<PostVoucherState> {
  PostVoucherCubit() : super(PostVoucherInitial());

  Future<void> exchangeVoucher({
    required int customerId,
    required int voucherId,
  }) async {
    emit(PostVoucherLoading());

    try {
      final result = await sl<PostVoucherUseCase>().call(
        params: {
          'customerId': customerId,
          'voucherId': voucherId,
        },
      );

      result.fold(
        (error) {
          emit(PostVoucherError(message: error.toString()));
        },
        (success) {
          emit(PostVoucherSuccess(
            message: 'Đổi voucher thành công!',
            data: success,
          ));
        },
      );
    } catch (e) {
      emit(PostVoucherError(message: 'Có lỗi xảy ra: ${e.toString()}'));
    }
  }

  void reset() {
    emit(PostVoucherInitial());
  }
}
