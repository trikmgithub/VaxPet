import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

enum AppointmentVaccinationNoteDetailStatus {
  initial,
  loading,
  success,
  failure,
}

class AppointmentVaccinationNoteDetailState extends Equatable {
  final AppointmentVaccinationNoteDetailStatus status;
  final Either? appointmentDetail;
  final String? errorMessage;

  const AppointmentVaccinationNoteDetailState({
    this.status = AppointmentVaccinationNoteDetailStatus.initial,
    this.appointmentDetail,
    this.errorMessage,
  });

  AppointmentVaccinationNoteDetailState copyWith({
    AppointmentVaccinationNoteDetailStatus? status,
    Either? appointmentDetail,
    String? errorMessage,
  }) {
    return AppointmentVaccinationNoteDetailState(
      status: status ?? this.status,
      appointmentDetail: appointmentDetail ?? this.appointmentDetail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, appointmentDetail, errorMessage];
}
