import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/appointment_vaccination_note_detail_cubit.dart';
import '../widgets/appointment_vaccination_note_detail.dart';

class AppointmentVaccinationNoteDetailPage extends StatelessWidget {
  final int appointmentId;

  const AppointmentVaccinationNoteDetailPage({
    super.key,
    required this.appointmentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết lịch hẹn tiêm phòng'),
      ),
      body: BlocProvider(
        create: (context) => AppointmentVaccinationNoteDetailCubit()..fetchAppointmentDetail(appointmentId),
        child: const AppointmentVaccinationDetail(),
      ),
    );
  }
}
