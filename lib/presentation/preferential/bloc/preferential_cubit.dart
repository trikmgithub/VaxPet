import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaxpet/domain/membership/usecases/get_customer_ranking_info.dart';
import 'package:vaxpet/presentation/preferential/bloc/preferential_state.dart';
import 'package:vaxpet/service_locator.dart';

class PreferentialCubit extends Cubit<PreferentialState> {
  final GetCustomerRankingInfoUseCase _getCustomerRankingInfoUseCase;

  PreferentialCubit({
    required GetCustomerRankingInfoUseCase getCustomerRankingInfoUseCase,
  })  : _getCustomerRankingInfoUseCase = getCustomerRankingInfoUseCase,
        super(PreferentialInitial());

  Future<void> loadCustomerRankingInfo() async {
    emit(PreferentialLoading());

    try {
      // Get customerId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('customerId');

      if (customerId == null) {
        emit(const PreferentialError(message: 'Không tìm thấy thông tin khách hàng'));
        return;
      }

      // Call the use case
      final result = await _getCustomerRankingInfoUseCase.call(params: customerId);

      result.fold(
        (failure) {
          emit(PreferentialError(message: failure.toString()));
        },
        (data) {
          final customerRankingInfo = CustomerRankingInfo.fromJson(data['data']);
          emit(PreferentialLoaded(customerRankingInfo: customerRankingInfo));
        },
      );
    } catch (e) {
      emit(PreferentialError(message: 'Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  void refresh() {
    loadCustomerRankingInfo();
  }
}
