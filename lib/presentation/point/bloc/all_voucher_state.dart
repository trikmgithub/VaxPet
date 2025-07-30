import 'package:equatable/equatable.dart';

abstract class AllVoucherState extends Equatable {
  const AllVoucherState();

  @override
  List<Object?> get props => [];
}

class AllVoucherInitial extends AllVoucherState {}

class AllVoucherLoading extends AllVoucherState {}

class AllVoucherLoaded extends AllVoucherState {
  final List<dynamic> vouchers;
  final bool hasMore;
  final int currentPage;

  const AllVoucherLoaded({
    required this.vouchers,
    this.hasMore = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [vouchers, hasMore, currentPage];

  AllVoucherLoaded copyWith({
    List<dynamic>? vouchers,
    bool? hasMore,
    int? currentPage,
  }) {
    return AllVoucherLoaded(
      vouchers: vouchers ?? this.vouchers,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class AllVoucherError extends AllVoucherState {
  final String message;

  const AllVoucherError({required this.message});

  @override
  List<Object?> get props => [message];
}
