import 'package:equatable/equatable.dart';

abstract class SupportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SupportInitial extends SupportState {}

class SupportLoading extends SupportState {}

class SupportLoaded extends SupportState {
  final List<dynamic> supports;
  final int totalPages;
  final int currentPage;
  final bool hasMore;

  SupportLoaded({
    required this.supports,
    required this.totalPages,
    required this.currentPage,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [supports, totalPages, currentPage, hasMore];
}

class SupportError extends SupportState {
  final String message;

  SupportError(this.message);

  @override
  List<Object?> get props => [message];
}

class SupportLoadingMore extends SupportLoaded {
  SupportLoadingMore({
    required List<dynamic> supports,
    required int totalPages,
    required int currentPage,
    required bool hasMore,
  }) : super(
          supports: supports,
          totalPages: totalPages,
          currentPage: currentPage,
          hasMore: hasMore,
        );
}
