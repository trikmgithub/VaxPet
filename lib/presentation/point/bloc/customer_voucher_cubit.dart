import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/voucher/usecases/get_customer_vouchers.dart';
import '../../../service_locator.dart';
import 'customer_voucher_state.dart';

class CustomerVoucherCubit extends Cubit<CustomerVoucherState> {
  CustomerVoucherCubit() : super(CustomerVoucherLoading());

  void getCustomerVouchers() async {
    try {
      emit(CustomerVoucherLoading());

      // Get customer ID from SharedPreferences
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final int? customerId = sharedPreferences.getInt('customerId');

      if (customerId == null) {
        emit(CustomerVoucherFailure(errorMessage: 'Không thể lấy thông tin khách hàng'));
        return;
      }

      // Get customer vouchers using the customer ID
      var voucherResult = await sl<GetCustomerVouchersUseCase>().call(params: customerId);

      voucherResult.fold(
        (failure) {
          emit(CustomerVoucherFailure(errorMessage: 'Không thể tải danh sách voucher'));
        },
        (response) {
          // Extract data from the API response
          if (response is Map<String, dynamic> && response['data'] != null) {
            final List<dynamic> vouchers = response['data'];
            emit(CustomerVoucherLoaded(customerVouchers: vouchers));
          } else {
            emit(CustomerVoucherFailure(errorMessage: 'Dữ liệu không hợp lệ'));
          }
        },
      );
    } catch (e) {
      emit(CustomerVoucherFailure(errorMessage: 'Đã xảy ra lỗi: ${e.toString()}'));
    }
  }
}
