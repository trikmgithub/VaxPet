import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/voucher/usecases/get_all_vouchers.dart';
import '../../../service_locator.dart';
import 'all_voucher_state.dart';

class AllVoucherCubit extends Cubit<AllVoucherState> {
  AllVoucherCubit() : super(AllVoucherInitial());

  List<dynamic> _allVouchers = [];
  String _currentKeyword = '';
  bool? _currentStatus;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;

  Future<void> getAllVouchers({
    int pageNumber = 1,
    int pageSize = 10,
    String? keyWord,
    bool? status,
    bool isRefresh = false,
  }) async {
    try {
      // Prevent loading more if already loading
      if (_isLoadingMore && pageNumber > 1) return;

      if (isRefresh || pageNumber == 1) {
        emit(AllVoucherLoading());
        _allVouchers.clear();
        _currentPage = 1;
      } else {
        _isLoadingMore = true;
      }

      _currentKeyword = keyWord ?? '';
      _currentStatus = status;

      final params = <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };

      if (keyWord != null && keyWord.isNotEmpty) {
        params['keyWord'] = keyWord;
      }

      if (status != null) {
        params['status'] = status;
      }

      var result = await sl<GetAllVouchersUseCase>().call(params: params);

      result.fold(
        (error) {
          _isLoadingMore = false;
          emit(AllVoucherError(message: error.toString()));
        },
        (data) {
          _isLoadingMore = false;

          if (data != null) {
            List<dynamic> newVouchers = [];

            // Handle the actual API response structure
            if (data is Map<String, dynamic>) {
              // Check for the actual API response structure
              if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
                final dataMap = data['data'] as Map<String, dynamic>;

                // Extract pagination info
                if (dataMap.containsKey('pageInfo')) {
                  final pageInfo = dataMap['pageInfo'] as Map<String, dynamic>;
                  _totalPages = pageInfo['totalPage'] ?? 1;
                  _currentPage = pageInfo['page'] ?? pageNumber;
                }

                // Extract vouchers
                if (dataMap.containsKey('pageData')) {
                  newVouchers = dataMap['pageData'] as List<dynamic>? ?? [];
                }
              } else if (data.containsKey('data') && data['data'] is List<dynamic>) {
                newVouchers = data['data'] as List<dynamic>;
              } else if (data.containsKey('vouchers')) {
                newVouchers = data['vouchers'] as List<dynamic>? ?? [];
              } else if (data.containsKey('pageData')) {
                newVouchers = data['pageData'] as List<dynamic>? ?? [];
              }
            } else if (data is List<dynamic>) {
              newVouchers = data;
            }

            if (pageNumber == 1) {
              _allVouchers = newVouchers;
            } else {
              _allVouchers.addAll(newVouchers);
            }

            // Check if there are more pages based on API response
            bool hasMore = _currentPage < _totalPages;

            emit(AllVoucherLoaded(
              vouchers: List.from(_allVouchers),
              hasMore: hasMore,
              currentPage: _currentPage,
            ));
          } else {
            emit(const AllVoucherError(message: 'No data received'));
          }
        },
      );
    } catch (e) {
      _isLoadingMore = false;
      emit(AllVoucherError(message: e.toString()));
    }
  }

  Future<void> loadMoreVouchers() async {
    if (state is AllVoucherLoaded && !_isLoadingMore) {
      final currentState = state as AllVoucherLoaded;
      if (currentState.hasMore) {
        await getAllVouchers(
          pageNumber: _currentPage + 1,
          keyWord: _currentKeyword.isEmpty ? null : _currentKeyword,
          status: _currentStatus,
        );
      }
    }
  }

  Future<void> refreshVouchers() async {
    await getAllVouchers(
      pageNumber: 1,
      keyWord: _currentKeyword.isEmpty ? null : _currentKeyword,
      status: _currentStatus,
      isRefresh: true,
    );
  }

  Future<void> searchVouchers(String keyword) async {
    await getAllVouchers(
      pageNumber: 1,
      keyWord: keyword,
      status: _currentStatus,
      isRefresh: true,
    );
  }

  Future<void> filterByStatus(bool? status) async {
    await getAllVouchers(
      pageNumber: 1,
      keyWord: _currentKeyword.isEmpty ? null : _currentKeyword,
      status: status,
      isRefresh: true,
    );
  }
}
