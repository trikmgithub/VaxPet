import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

enum AppointmentMicrochipNoteDetailStatus {
  initial,
  loading,
  success,
  failure,
}

class AppointmentMicrochipNoteDetailState extends Equatable {
  final AppointmentMicrochipNoteDetailStatus status;
  final Either? appointmentDetail;
  final String? errorMessage;

  const AppointmentMicrochipNoteDetailState({
    this.status = AppointmentMicrochipNoteDetailStatus.initial,
    this.appointmentDetail,
    this.errorMessage,
  });

  AppointmentMicrochipNoteDetailState copyWith({
    AppointmentMicrochipNoteDetailStatus? status,
    Either? appointmentDetail,
    String? errorMessage,
  }) {
    return AppointmentMicrochipNoteDetailState(
      status: status ?? this.status,
      appointmentDetail: appointmentDetail ?? this.appointmentDetail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, appointmentDetail, errorMessage];
}
