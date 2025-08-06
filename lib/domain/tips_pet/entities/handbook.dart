class HandbookEntity {
  final int handbookId;
  final String title;
  final String introduction;
  final String highlight;
  final String content;
  final String importantNote;
  final String? imageUrl;
  final String createdAt;
  final String createdBy;
  final String? modifiedAt;
  final String? modifiedBy;
  final bool isDeleted;

  HandbookEntity({
    required this.handbookId,
    required this.title,
    required this.introduction,
    required this.highlight,
    required this.content,
    required this.importantNote,
    this.imageUrl,
    required this.createdAt,
    required this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
    required this.isDeleted,
  });
}

class HandbookResponseEntity {
  final int code;
  final bool success;
  final String message;
  final HandbookDataEntity data;

  HandbookResponseEntity({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });
}

class HandbookDataEntity {
  final PageInfoEntity pageInfo;
  final SearchInfoEntity searchInfo;
  final List<HandbookEntity> pageData;

  HandbookDataEntity({
    required this.pageInfo,
    required this.searchInfo,
    required this.pageData,
  });
}

class PageInfoEntity {
  final int page;
  final int size;
  final String? sort;
  final String? order;
  final int totalPage;
  final int totalItem;

  PageInfoEntity({
    required this.page,
    required this.size,
    this.sort,
    this.order,
    required this.totalPage,
    required this.totalItem,
  });
}

class SearchInfoEntity {
  final String? keyWord;
  final String? role;
  final bool? status;
  final bool? isVerify;
  final bool? isDelete;

  SearchInfoEntity({
    this.keyWord,
    this.role,
    this.status,
    this.isVerify,
    this.isDelete,
  });
}
