import 'package:equatable/equatable.dart';

enum AppointmentHealthCertificateNoteCancelStatus {
  initial,
  loading,
  success,
  failure,
}

class AppointmentHealthCertificateNoteCancelState extends Equatable {
  final AppointmentHealthCertificateNoteCancelStatus status;
  final String? errorMessage;

  const AppointmentHealthCertificateNoteCancelState({
    this.status = AppointmentHealthCertificateNoteCancelStatus.initial,
    this.errorMessage,
  });

  AppointmentHealthCertificateNoteCancelState copyWith({
    AppointmentHealthCertificateNoteCancelStatus? status,
    String? errorMessage,
  }) {
    return AppointmentHealthCertificateNoteCancelState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
