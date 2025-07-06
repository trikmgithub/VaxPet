import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/common/widgets/app_bar/app_bar.dart';

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
      appBar: BasicAppbar(
        title: const Text(
          'Ghi chú tiêm chủng',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => AppointmentVaccinationNoteCubit(),
        child: Column(
          children: [Expanded(child: AppointmentVaccinationNote(petId: petId))],
        ),
      ),
    );
  }
}
