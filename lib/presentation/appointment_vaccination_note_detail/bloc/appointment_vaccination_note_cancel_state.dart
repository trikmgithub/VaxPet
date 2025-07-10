enum AppointmentVaccinationNoteCancelStatus {
  initial,
  loading,
  success,
  failure,
}

class AppointmentVaccinationNoteCancelState {
  final AppointmentVaccinationNoteCancelStatus status;
  final String? errorMessage;
  final String? successMessage;

  const AppointmentVaccinationNoteCancelState({
    this.status = AppointmentVaccinationNoteCancelStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  AppointmentVaccinationNoteCancelState copyWith({
    AppointmentVaccinationNoteCancelStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return AppointmentVaccinationNoteCancelState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  bool get isLoading => status == AppointmentVaccinationNoteCancelStatus.loading;
  bool get isSuccess => status == AppointmentVaccinationNoteCancelStatus.success;
  bool get isFailure => status == AppointmentVaccinationNoteCancelStatus.failure;
}
