import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/tips_pet/usecases/get_all_handbooks.dart';
import '../../../domain/tips_pet/entities/handbook.dart';
import '../../../service_locator.dart';
import 'tips_pet_state.dart';

class TipsPetCubit extends Cubit<TipsPetState> {
  TipsPetCubit() : super(TipsPetInitial());

  List<HandbookEntity> _allHandbooks = [];
  bool _hasReachedMax = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  String? _currentKeyword;

  Future<void> getAllHandbooks({
    int pageNumber = 1,
    int pageSize = 10,
    String? keyWord,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      _currentPage = 1;
      _allHandbooks.clear();
      _hasReachedMax = false;
      _currentKeyword = keyWord;
    }

    // If already loading or reached max, don't make another request
    if (state is TipsPetLoading && !isRefresh) return;
    if (_hasReachedMax && !isRefresh) return;

    // If this is a new search (different keyword), reset everything
    if (_currentKeyword != keyWord && !isRefresh) {
      _currentPage = 1;
      _allHandbooks.clear();
      _hasReachedMax = false;
      _currentKeyword = keyWord;
    }

    if (_allHandbooks.isEmpty) {
      emit(TipsPetLoading());
    } else {
      emit(TipsPetLoadingMore(handbooks: _allHandbooks, pageInfo: _getPageInfo()));
    }

    try {
      final params = <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        if (keyWord != null && keyWord.isNotEmpty) 'keyWord': keyWord,
      };

      final result = await sl<GetAllHandbooksUseCase>().call(params: params);

      result.fold(
        (failure) {
          emit(TipsPetFailure(message: failure.toString()));
        },
        (data) {
          if (data is Map<String, dynamic>) {
            final response = _parseHandbookResponse(data);
            final newHandbooks = response.data.pageData;

            if (isRefresh) {
              _allHandbooks = newHandbooks;
            } else {
              _allHandbooks.addAll(newHandbooks);
            }

            // Check if we've reached the end
            if (newHandbooks.length < pageSize) {
              _hasReachedMax = true;
            }

            _currentPage = pageNumber;

            emit(TipsPetSuccess(
              handbooks: _allHandbooks,
              pageInfo: response.data.pageInfo,
              hasReachedMax: _hasReachedMax,
            ));
          } else {
            emit(const TipsPetFailure(message: 'Invalid data format'));
          }
        },
      );
    } catch (e) {
      emit(TipsPetFailure(message: e.toString()));
    }
  }

  Future<void> loadMoreHandbooks() async {
    if (_hasReachedMax) return;

    await getAllHandbooks(
      pageNumber: _currentPage + 1,
      pageSize: _pageSize,
      keyWord: _currentKeyword,
    );
  }

  Future<void> refreshHandbooks({String? keyWord}) async {
    await getAllHandbooks(
      pageNumber: 1,
      pageSize: _pageSize,
      keyWord: keyWord,
      isRefresh: true,
    );
  }

  Future<void> searchHandbooks(String keyword) async {
    await getAllHandbooks(
      pageNumber: 1,
      pageSize: _pageSize,
      keyWord: keyword,
      isRefresh: true,
    );
  }

  PageInfoEntity _getPageInfo() {
    return PageInfoEntity(
      page: _currentPage,
      size: _pageSize,
      sort: null,
      order: null,
      totalPage: (_allHandbooks.length / _pageSize).ceil(),
      totalItem: _allHandbooks.length,
    );
  }

  HandbookResponseEntity _parseHandbookResponse(Map<String, dynamic> json) {
    return HandbookResponseEntity(
      code: json['code'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: _parseHandbookData(json['data'] ?? {}),
    );
  }

  HandbookDataEntity _parseHandbookData(Map<String, dynamic> json) {
    return HandbookDataEntity(
      pageInfo: _parsePageInfo(json['pageInfo'] ?? {}),
      searchInfo: _parseSearchInfo(json['searchInfo'] ?? {}),
      pageData: (json['pageData'] as List?)
          ?.map((item) => _parseHandbook(item))
          .toList() ?? [],
    );
  }

  PageInfoEntity _parsePageInfo(Map<String, dynamic> json) {
    return PageInfoEntity(
      page: json['pageNumber'] ?? json['page'] ?? 1,
      size: json['pageSize'] ?? json['size'] ?? 10,
      sort: json['sort'],
      order: json['order'],
      totalPage: json['totalPage'] ?? 1,
      totalItem: json['totalItem'] ?? 0,
    );
  }

  SearchInfoEntity _parseSearchInfo(Map<String, dynamic> json) {
    return SearchInfoEntity(
      keyWord: json['keyWord'],
      role: json['role'],
      status: json['status'],
      isVerify: json['is_Verify'],
      isDelete: json['is_Delete'],
    );
  }

  HandbookEntity _parseHandbook(Map<String, dynamic> json) {
    return HandbookEntity(
      handbookId: json['handbookId'] ?? 0,
      title: json['title'] ?? '',
      introduction: json['introduction'] ?? '',
      highlight: json['highlight'] ?? '',
      content: json['content'] ?? '',
      importantNote: json['importantNote'] ?? '',
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'] ?? '',
      createdBy: json['createdBy'] ?? '',
      modifiedAt: json['modifiedAt'],
      modifiedBy: json['modifiedBy'],
      isDeleted: json['isDeleted'] ?? false,
    );
  }
}
