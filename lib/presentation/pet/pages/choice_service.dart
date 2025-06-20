import 'package:flutter/material.dart';
import 'package:vaxpet/common/widgets/back_button/back_button.dart';
import 'package:vaxpet/presentation/schedule/pages/vaccination_schedule_home.dart';
import 'package:vaxpet/presentation/pet/widgets/category_text.dart';
import '../../../common/helper/navigation/app_navigation.dart';
import '../widgets/box_text.dart';

class ChoiceServicePage extends StatelessWidget {
  final String petName;
  final int petId;
  final String petSpecies;
  const ChoiceServicePage({super.key, required this.petName, required this.petId, required this.petSpecies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 0, right: 24, left: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButtonBasic(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CategoryText(
                    title:
                        'Tiếp tục đặt lịch tiêm vắc xin với ${petName ?? "thú cưng"}',
                    sizeTitle: 28,
                  ),
                ),
                const SizedBox(height: 16),
                BoxText(
                  title: 'Tiêm tại nhà',
                  icon: Icons.home,
                  widthWords: 200,
                  sizeTitle: 16,
                  onTap: () {
                    if (petName == null || petId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Thông tin thú cưng không hợp lệ')),
                      );
                      return;
                    }
                    AppNavigator.push(
                      context,
                      VaccinationScheduleHomePage(petName: petName, petId: petId, petSpecies: petSpecies,),
                    );
                  }
                ),
                const SizedBox(height: 16),
                const BoxText(
                  title: 'Tiêm tại trung tâm',
                  icon: Icons.local_hospital,
                  widthWords: 200,
                  sizeTitle: 16,
                  heightTitle: 80,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
