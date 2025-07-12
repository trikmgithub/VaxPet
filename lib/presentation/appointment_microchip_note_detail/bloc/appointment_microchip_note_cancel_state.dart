enum AppointmentMicrochipNoteCancelStatus {
  initial,
  loading,
  success,
  failure,
}

class AppointmentMicrochipNoteCancelState {
  final AppointmentMicrochipNoteCancelStatus status;
  final String? errorMessage;
  final String? successMessage;

  const AppointmentMicrochipNoteCancelState({
    this.status = AppointmentMicrochipNoteCancelStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  AppointmentMicrochipNoteCancelState copyWith({
    AppointmentMicrochipNoteCancelStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return AppointmentMicrochipNoteCancelState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  bool get isLoading => status == AppointmentMicrochipNoteCancelStatus.loading;
  bool get isSuccess => status == AppointmentMicrochipNoteCancelStatus.success;
  bool get isFailure => status == AppointmentMicrochipNoteCancelStatus.failure;
}
