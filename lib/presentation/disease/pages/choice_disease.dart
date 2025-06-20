import 'package:flutter/material.dart';
import 'package:vaxpet/presentation/pet/widgets/category_text.dart';

import '../../../common/widgets/back_button/back_button.dart';
import '../widgets/disease_species.dart';

class ChoiceDiseasePage extends StatelessWidget {
  final String species;
  const ChoiceDiseasePage({super.key, required this.species});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButtonBasic(),
            Center(
              child: CategoryText(
                title: 'Chọn bệnh cần tiêm vắc xin',
                sizeTitle: 20,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            CategoryText(
              title: 'Loài: $species',
              sizeTitle: 16
            ),
            const SizedBox(height: 16),
            Expanded(
              child: DiseaseSpecies(species: species),
            ),
          ],
        ),
      )
    );
  }
}
