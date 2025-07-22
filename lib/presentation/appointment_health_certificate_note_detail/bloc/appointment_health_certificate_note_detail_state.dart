import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

enum AppointmentHealthCertificateNoteDetailStatus {
  initial,
  loading,
  success,
  failure,
}

class AppointmentHealthCertificateNoteDetailState extends Equatable {
  final AppointmentHealthCertificateNoteDetailStatus status;
  final Either? appointmentDetail;
  final String? errorMessage;

  const AppointmentHealthCertificateNoteDetailState({
    this.status = AppointmentHealthCertificateNoteDetailStatus.initial,
    this.appointmentDetail,
    this.errorMessage,
  });

  AppointmentHealthCertificateNoteDetailState copyWith({
    AppointmentHealthCertificateNoteDetailStatus? status,
    Either? appointmentDetail,
    String? errorMessage,
  }) {
    return AppointmentHealthCertificateNoteDetailState(
      status: status ?? this.status,
      appointmentDetail: appointmentDetail ?? this.appointmentDetail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, appointmentDetail, errorMessage];
}
