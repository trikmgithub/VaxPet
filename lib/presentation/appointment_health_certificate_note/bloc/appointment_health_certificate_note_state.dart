import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

enum AppointmentHealthCertificateNoteStatus { initial, loading, success, failure }

class AppointmentHealthCertificateNoteState extends Equatable {
  final AppointmentHealthCertificateNoteStatus status;
  final Either<String, List<dynamic>>? pendingAppointments;
  final Either<String, List<dynamic>>? confirmedAppointments;
  final String? errorMessage;
  final Map<int, List<dynamic>> appointmentsByStatus;
  final List<int> availableStatuses;
  final int? selectedStatusFilter;

  const AppointmentHealthCertificateNoteState({
    this.status = AppointmentHealthCertificateNoteStatus.initial,
    this.pendingAppointments,
    this.confirmedAppointments,
    this.errorMessage,
    this.appointmentsByStatus = const {},
    this.availableStatuses = const [],
    this.selectedStatusFilter,
  });

  @override
  List<Object?> get props => [
        status,
        pendingAppointments,
        confirmedAppointments,
        errorMessage,
        appointmentsByStatus,
        availableStatuses,
        selectedStatusFilter,
      ];

  AppointmentHealthCertificateNoteState copyWith({
    AppointmentHealthCertificateNoteStatus? status,
    Either<String, List<dynamic>>? pendingAppointments,
    Either<String, List<dynamic>>? confirmedAppointments,
    String? errorMessage,
    Map<int, List<dynamic>>? appointmentsByStatus,
    List<int>? availableStatuses,
    int? selectedStatusFilter,
    bool clearFilter = false,
  }) {
    return AppointmentHealthCertificateNoteState(
      status: status ?? this.status,
      pendingAppointments: pendingAppointments ?? this.pendingAppointments,
      confirmedAppointments: confirmedAppointments ?? this.confirmedAppointments,
      errorMessage: errorMessage ?? this.errorMessage,
      appointmentsByStatus: appointmentsByStatus ?? this.appointmentsByStatus,
      availableStatuses: availableStatuses ?? this.availableStatuses,
      selectedStatusFilter: clearFilter ? null : (selectedStatusFilter ?? this.selectedStatusFilter),
    );
  }
}
