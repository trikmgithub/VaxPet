import 'package:flutter/material.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/presentation/pet/widgets/box_text.dart';
import 'package:vaxpet/presentation/pet/widgets/category_text.dart';

import '../../../common/widgets/back_button/back_button.dart';
import '../../../core/configs/theme/app_colors.dart';
import 'choice_service.dart';

class PetDetailsPage extends StatelessWidget {
  final int petId;
  final String petName;
  final String? petImage;
  final String petSpecies;
  const PetDetailsPage({super.key, required this.petId, required this.petName, this.petImage, required this.petSpecies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        minimum: const EdgeInsets.only(
          right: 12,
          left: 12,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButtonBasic(),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, -16))],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: petImage != null && petImage!.isNotEmpty
                              ? NetworkImage(petImage!)
                              : null,
                          child: petImage == null || petImage!.isEmpty
                              ? Icon(Icons.pets, size: 40, color: Colors.grey[600])
                              : null,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          petName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                CategoryText(title: 'Đặt dịch vụ'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BoxText(title: 'Vắc xin', icon: Icons.vaccines, onTap: () {
                      AppNavigator.push(context, ChoiceServicePage(petName: petName, petId: petId, petSpecies: petSpecies,));
                    }),
                    BoxText(title: 'Microchip', icon: Icons.qr_code, onTap: () {
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                BoxText(title: 'Chứng nhận sức khỏe', icon: Icons.book, onTap: () {
                }),
                const SizedBox(height: 16),
                CategoryText(title: 'Sổ ghi chép'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BoxText(title: 'Vắc xin', icon: Icons.vaccines, onTap: () {
                    }),
                    BoxText(title: 'Microchip', icon: Icons.qr_code, onTap: () {
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BoxText(title: 'Chứng nhận sức khỏe', icon: Icons.book, onTap: () {
                    }),
                    BoxText(title: 'Lịch gợi ý', icon: Icons.calendar_month, onTap: () {
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                BoxText(title: 'Cẩm nang', icon: Icons.tips_and_updates, onTap: () {
                }),
                const SizedBox(height: 20),
                CategoryText(title: 'Thông tin thú cưng'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BoxText(title: 'Thông tin', icon: Icons.medical_information, onTap: () {
                    }),
                    BoxText(title: 'Hồ sơ tiêm chủng', icon: Icons.emergency_recording, onTap: () {
                    }),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            )
          ),
        )
      )
     );
   }
 }
