import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/appointment_vaccination_note_cubit.dart';
import '../widgets/appointment_vaccination_note.dart';

class AppointmentVaccinationNotePage extends StatelessWidget {
  final String petName;
  final int petId;
  final String petSpecies;

  const AppointmentVaccinationNotePage({
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
        create: (context) => AppointmentVaccinationNoteCubit(),
        child: Column(
          children: [
            Expanded(
              child: AppointmentVaccinationNote(petId: petId),
            ),
          ]
        ),
      )
    );
  }
}
