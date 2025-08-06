import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/helps/usecases/get_supports.dart';
import '../../../service_locator.dart';
import 'support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  SupportCubit() : super(SupportInitial());

  List<dynamic> _allSupports = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;

  Future<void> getSupports({
    int pageNumber = 1,
    int pageSize = 10,
    String? keyword,
    bool isLoadMore = false,
  }) async {
    if (_isLoadingMore) return;

    if (!isLoadMore) {
      emit(SupportLoading());
      _currentPage = 1;
      _allSupports.clear();
    } else {
      _isLoadingMore = true;
      emit(SupportLoadingMore(
        supports: _allSupports,
        totalPages: 0,
        currentPage: _currentPage,
        hasMore: true,
      ));
    }

    try {
      final params = <String, dynamic>{
        'pageNumber': isLoadMore ? _currentPage + 1 : pageNumber,
        'pageSize': pageSize,
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
      };

      final result = await sl<GetSupportsUseCase>().call(params: params);

      result.fold(
        (error) {
          _isLoadingMore = false;
          emit(SupportError(error.toString()));
        },
        (response) {
          _isLoadingMore = false;

          if (response != null && response['data'] != null) {
            final data = response['data'];
            final pageInfo = data['pageInfo'];
            final List<dynamic> newSupports = data['pageData'] ?? [];

            if (isLoadMore) {
              _allSupports.addAll(newSupports);
              _currentPage++;
            } else {
              _allSupports = newSupports;
              _currentPage = pageInfo['page'] ?? 1;
            }

            final totalPages = pageInfo['totalPage'] ?? 1;
            final hasMore = _currentPage < totalPages;

            emit(SupportLoaded(
              supports: _allSupports,
              totalPages: totalPages,
              currentPage: _currentPage,
              hasMore: hasMore,
            ));
          } else {
            emit(SupportError('Không có dữ liệu'));
          }
        },
      );
    } catch (e) {
      _isLoadingMore = false;
      emit(SupportError('Có lỗi xảy ra: ${e.toString()}'));
    }
  }

  Future<void> loadMoreSupports({String? keyword}) async {
    if (state is SupportLoaded) {
      final currentState = state as SupportLoaded;
      if (currentState.hasMore) {
        await getSupports(
          pageNumber: _currentPage + 1,
          keyword: keyword,
          isLoadMore: true,
        );
      }
    }
  }

  Future<void> searchSupports(String keyword) async {
    await getSupports(keyword: keyword);
  }

  void reset() {
    _allSupports.clear();
    _currentPage = 1;
    _isLoadingMore = false;
    emit(SupportInitial());
  }
}
