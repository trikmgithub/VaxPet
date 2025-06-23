import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/presentation/vaccine_appointment_note/bloc/vaccine_appointment_note_detail_cubit.dart';
import 'package:vaxpet/presentation/vaccine_appointment_note/widgets/vaccine_appointment_detail.dart';

class VaccineAppointmentNoteDetailPage extends StatelessWidget {
  final int appointmentId;

  const VaccineAppointmentNoteDetailPage({
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
        create: (context) => VaccineAppointmentNoteDetailCubit()..fetchAppointmentDetail(appointmentId),
        child: const VaccineAppointmentDetail(),
      ),
    );
  }
}
