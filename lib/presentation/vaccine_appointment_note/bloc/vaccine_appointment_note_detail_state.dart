import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

enum VaccineAppointmentNoteDetailStatus { initial, loading, success, failure }

class VaccineAppointmentNoteDetailState extends Equatable {
  final VaccineAppointmentNoteDetailStatus status;
  final Either? appointmentDetail;
  final String? errorMessage;

  const VaccineAppointmentNoteDetailState({
    this.status = VaccineAppointmentNoteDetailStatus.initial,
    this.appointmentDetail,
    this.errorMessage,
  });

  VaccineAppointmentNoteDetailState copyWith({
    VaccineAppointmentNoteDetailStatus? status,
    Either? appointmentDetail,
    String? errorMessage,
  }) {
    return VaccineAppointmentNoteDetailState(
      status: status ?? this.status,
      appointmentDetail: appointmentDetail ?? this.appointmentDetail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, appointmentDetail, errorMessage];
}
