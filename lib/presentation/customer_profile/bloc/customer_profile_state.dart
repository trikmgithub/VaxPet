
import '../../../domain/customer_profile/entities/customer_profile.dart';

abstract class CustomerProfileState {}

class CustomerProfileLoading extends CustomerProfileState {}

class CustomerProfileLoaded extends CustomerProfileState {
  final CustomerProfileEntity customerProfile;
  CustomerProfileLoaded({required this.customerProfile});
}

class CustomerProfileError extends CustomerProfileState {
  final String errorMessage;
  CustomerProfileError({required this.errorMessage});
}