abstract class PostVoucherState {}

class PostVoucherInitial extends PostVoucherState {}

class PostVoucherLoading extends PostVoucherState {}

class PostVoucherSuccess extends PostVoucherState {
  final String message;
  final Map<String, dynamic>? data;

  PostVoucherSuccess({
    required this.message,
    this.data,
  });
}

class PostVoucherError extends PostVoucherState {
  final String message;

  PostVoucherError({required this.message});
}
