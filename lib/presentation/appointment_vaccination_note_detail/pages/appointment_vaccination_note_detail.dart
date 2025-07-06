import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/common/widgets/app_bar/app_bar.dart';
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
      backgroundColor: Colors.grey[50],
      appBar: BasicAppbar(
        title: const Text(
          'Chi tiết lịch hẹn',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocProvider(
        create:
            (context) =>
                AppointmentVaccinationNoteDetailCubit()
                  ..fetchAppointmentDetail(appointmentId),
        child: const AppointmentVaccinationDetail(),
      ),
    );
  }
}
