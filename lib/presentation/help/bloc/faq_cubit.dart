import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/helps/usecases/get_faq.dart';
import '../../../service_locator.dart';
import 'faq_state.dart';

class FAQCubit extends Cubit<FAQState> {
  FAQCubit() : super(FAQInitial());

  List<dynamic> _allFaqs = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;

  Future<void> getFAQs({
    int pageNumber = 1,
    int pageSize = 10,
    String? keyword,
    bool isLoadMore = false,
  }) async {
    if (_isLoadingMore) return;

    if (!isLoadMore) {
      emit(FAQLoading());
      _currentPage = 1;
      _allFaqs.clear();
    } else {
      _isLoadingMore = true;
      emit(FAQLoadingMore(
        faqs: _allFaqs,
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

      final result = await sl<GetFAQUseCase>().call(params: params);

      result.fold(
        (error) {
          _isLoadingMore = false;
          emit(FAQError(error.toString()));
        },
        (response) {
          _isLoadingMore = false;

          // Debug print to see the complete API response
          print('FAQ API Response: $response');

          if (response != null && response['data'] != null) {
            final data = response['data'];
            final pageInfo = data['pageInfo'];
            final List<dynamic> newFaqs = data['pageData'] ?? [];

            // Debug print to see the extracted FAQ data
            print('FAQ pageData: $newFaqs');
            print('FAQ pageInfo: $pageInfo');

            if (isLoadMore) {
              _allFaqs.addAll(newFaqs);
              _currentPage++;
            } else {
              _allFaqs = newFaqs;
              _currentPage = pageInfo['page'] ?? 1;
            }

            final totalPages = pageInfo['totalPage'] ?? 1;
            final hasMore = _currentPage < totalPages;

            print('FAQ Final State - FAQs count: ${_allFaqs.length}, hasMore: $hasMore');

            emit(FAQLoaded(
              faqs: _allFaqs,
              totalPages: totalPages,
              currentPage: _currentPage,
              hasMore: hasMore,
            ));
          } else {
            emit(FAQError('Không có dữ liệu'));
          }
        },
      );
    } catch (e) {
      _isLoadingMore = false;
      emit(FAQError('Có lỗi xảy ra: ${e.toString()}'));
    }
  }

  Future<void> loadMoreFAQs({String? keyword}) async {
    if (state is FAQLoaded) {
      final currentState = state as FAQLoaded;
      if (currentState.hasMore) {
        await getFAQs(
          pageNumber: _currentPage + 1,
          keyword: keyword,
          isLoadMore: true,
        );
      }
    }
  }

  Future<void> searchFAQs(String keyword) async {
    await getFAQs(keyword: keyword);
  }

  void reset() {
    _allFaqs.clear();
    _currentPage = 1;
    _isLoadingMore = false;
    emit(FAQInitial());
  }
}
