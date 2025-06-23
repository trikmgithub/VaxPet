import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

enum VaccineAppointmentStatus { initial, loading, success, failure }

class VaccineAppointmentState extends Equatable {
  final VaccineAppointmentStatus status;
  final Either? pendingAppointments;
  final Either? confirmedAppointments;
  final String? errorMessage;

  const VaccineAppointmentState({
    this.status = VaccineAppointmentStatus.initial,
    this.pendingAppointments,
    this.confirmedAppointments,
    this.errorMessage,
  });

  VaccineAppointmentState copyWith({
    VaccineAppointmentStatus? status,
    Either? pendingAppointments,
    Either? confirmedAppointments,
    String? errorMessage,
  }) {
    return VaccineAppointmentState(
      status: status ?? this.status,
      pendingAppointments: pendingAppointments ?? this.pendingAppointments,
      confirmedAppointments: confirmedAppointments ?? this.confirmedAppointments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, pendingAppointments, confirmedAppointments, errorMessage];
}
