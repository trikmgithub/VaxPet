import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

enum AppointmentVaccinationNoteStatus { initial, loading, success, failure }

class AppointmentVaccinationNoteState extends Equatable {
  final AppointmentVaccinationNoteStatus status;
  final Either? pendingAppointments;
  final Either? confirmedAppointments;
  final String? errorMessage;

  const AppointmentVaccinationNoteState({
    this.status = AppointmentVaccinationNoteStatus.initial,
    this.pendingAppointments,
    this.confirmedAppointments,
    this.errorMessage,
  });

  AppointmentVaccinationNoteState copyWith({
    AppointmentVaccinationNoteStatus? status,
    Either? pendingAppointments,
    Either? confirmedAppointments,
    String? errorMessage,
  }) {
    return AppointmentVaccinationNoteState(
      status: status ?? this.status,
      pendingAppointments: pendingAppointments ?? this.pendingAppointments,
      confirmedAppointments: confirmedAppointments ?? this.confirmedAppointments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, pendingAppointments, confirmedAppointments, errorMessage];
}
