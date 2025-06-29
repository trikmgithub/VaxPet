import '../../../domain/customer_profile/entities/customer_profile.dart';

abstract class CustomerProfileEditState {}

class CustomerProfileEditLoading extends CustomerProfileEditState {}

class CustomerProfileEditUpdated extends CustomerProfileEditState {
  final CustomerProfileEntity customerProfile;
  CustomerProfileEditUpdated({required this.customerProfile});
}

class CustomerProfileEditError extends CustomerProfileEditState {
  final String errorMessage;
  CustomerProfileEditError({required this.errorMessage});
}