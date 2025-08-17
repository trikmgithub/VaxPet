import 'package:flutter/material.dart';
import 'package:vaxpet/presentation/pet/widgets/category_text.dart';

import '../../../common/widgets/back_button/back_button.dart';
import '../widgets/disease_species.dart';

class ChoiceDiseasePage extends StatelessWidget {
  final String species;
  const ChoiceDiseasePage({super.key, required this.species});

  // Helper method to translate pet species to Vietnamese
  String _getVietnamesePetSpecies(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
      case 'chó':
        return 'Chó';
      case 'cat':
      case 'mèo':
        return 'Mèo';
      default:
        return species; // Return original if no translation found
    }
  }

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
            CategoryText(title: 'Loài: ${_getVietnamesePetSpecies(species)}', sizeTitle: 16),
            const SizedBox(height: 16),
            Expanded(child: DiseaseSpecies(species: species)),
          ],
        ),
      ),
    );
  }
}
