import 'package:equatable/equatable.dart';
import '../../../domain/tips_pet/entities/handbook.dart';

abstract class TipsPetState extends Equatable {
  const TipsPetState();

  @override
  List<Object?> get props => [];
}

class TipsPetInitial extends TipsPetState {}

class TipsPetLoading extends TipsPetState {}

class TipsPetLoadingMore extends TipsPetState {
  final List<HandbookEntity> handbooks;
  final PageInfoEntity pageInfo;

  const TipsPetLoadingMore({
    required this.handbooks,
    required this.pageInfo,
  });

  @override
  List<Object?> get props => [handbooks, pageInfo];
}

class TipsPetSuccess extends TipsPetState {
  final List<HandbookEntity> handbooks;
  final PageInfoEntity pageInfo;
  final bool hasReachedMax;

  const TipsPetSuccess({
    required this.handbooks,
    required this.pageInfo,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [handbooks, pageInfo, hasReachedMax];
}

class TipsPetFailure extends TipsPetState {
  final String message;

  const TipsPetFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
