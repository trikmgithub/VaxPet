import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/vaccine_appointment_note_cubit.dart';
import '../widgets/vaccine_appointment.dart';

class VaccineAppointmentNotePage extends StatelessWidget {
  final String petName;
  final int petId;
  final String petSpecies;

  const VaccineAppointmentNotePage({
    super.key,
    required this.petName,
    required this.petId,
    required this.petSpecies,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch hẹn tiêm phòng cho $petName'),
      ),
      body: BlocProvider(
        create: (context) => VaccineAppointmentCubit(),
        child: Column(
          children: [
            Expanded(
              child: VaccineAppointment(petId: petId),
            ),
          ]
        ),
      )
    );
  }
}
