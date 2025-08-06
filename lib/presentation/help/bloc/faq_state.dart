import 'package:equatable/equatable.dart';

abstract class FAQState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FAQInitial extends FAQState {}

class FAQLoading extends FAQState {}

class FAQLoaded extends FAQState {
  final List<dynamic> faqs;
  final int totalPages;
  final int currentPage;
  final bool hasMore;

  FAQLoaded({
    required this.faqs,
    required this.totalPages,
    required this.currentPage,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [faqs, totalPages, currentPage, hasMore];
}

class FAQError extends FAQState {
  final String message;

  FAQError(this.message);

  @override
  List<Object?> get props => [message];
}

class FAQLoadingMore extends FAQLoaded {
  FAQLoadingMore({
    required List<dynamic> faqs,
    required int totalPages,
    required int currentPage,
    required bool hasMore,
  }) : super(
          faqs: faqs,
          totalPages: totalPages,
          currentPage: currentPage,
          hasMore: hasMore,
        );
}
