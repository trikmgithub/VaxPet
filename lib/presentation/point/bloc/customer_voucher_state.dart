abstract class CustomerVoucherState {}

class CustomerVoucherLoading extends CustomerVoucherState {}

class CustomerVoucherLoaded extends CustomerVoucherState {
  final List<dynamic> customerVouchers;

  CustomerVoucherLoaded({required this.customerVouchers});
}

class CustomerVoucherFailure extends CustomerVoucherState {
  final String errorMessage;

  CustomerVoucherFailure({required this.errorMessage});
}
