import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/common/widgets/app_bar/app_bar.dart';

import '../bloc/appointment_microchip_note_cubit.dart';
import '../widgets/appointment_microchip_note.dart';

class AppointmentMicrochipNotePage extends StatelessWidget {
  final String petName;
  final int petId;
  final String petSpecies;

  const AppointmentMicrochipNotePage({
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
          'Ghi chú cấy chip',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => AppointmentMicrochipNoteCubit(),
        child: Column(
          children: [Expanded(child: AppointmentMicrochipNote(petId: petId))],
        ),
      ),
    );
  }
}
