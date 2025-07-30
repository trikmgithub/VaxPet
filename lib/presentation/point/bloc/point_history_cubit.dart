import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaxpet/presentation/point/bloc/point_history_state.dart';

import '../../../domain/point_transaction/usecases/get_point_transaction.dart';
import '../../../service_locator.dart';

class PointHistoryCubit extends Cubit<PointHistoryState> {
  PointHistoryCubit() : super(PointHistoryLoading());

  final GetPointTransactionUseCase _getPointTransactionUseCase = sl<GetPointTransactionUseCase>();

  Future<void> getPointHistory() async {
    try {
      emit(PointHistoryLoading());

      // Get customerId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('customerId');

      if (customerId == null) {
        emit(PointHistoryFailure(message: 'Không tìm thấy thông tin khách hàng'));
        return;
      }

      final result = await _getPointTransactionUseCase.call(params: customerId);

      result.fold(
        (error) {
          emit(PointHistoryFailure(message: 'Không thể tải lịch sử điểm'));
        },
        (data) {
          try {
            final List<PointTransaction> transactions = [];

            if (data['success'] == true && data['data'] != null) {
              final List<dynamic> transactionList = data['data'];
              for (var transactionData in transactionList) {
                transactions.add(PointTransaction.fromJson(transactionData));
              }
            }

            emit(PointHistoryLoaded(transactions: transactions));
          } catch (e) {
            emit(PointHistoryFailure(message: 'Lỗi xử lý dữ liệu'));
          }
        },
      );
    } catch (e) {
      emit(PointHistoryFailure(message: 'Đã xảy ra lỗi không mong muốn'));
    }
  }
}
