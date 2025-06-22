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
    // Lấy kích thước màn hình để tính toán tỷ lệ
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    // Tính toán padding dựa trên chiều rộng màn hình
    final double horizontalPadding = screenWidth * 0.04; // 4% của chiều rộng màn hình

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        minimum: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                          // Sử dụng tỷ lệ dựa trên chiều rộng màn hình
                          radius: screenWidth * 0.10, // 10% của chiều rộng màn hình
                          backgroundColor: Colors.white,
                          backgroundImage: petImage != null && petImage!.isNotEmpty
                              ? NetworkImage(petImage!)
                              : null,
                          child: petImage == null || petImage!.isEmpty
                              ? Icon(Icons.pets, size: screenWidth * 0.10, color: Colors.grey[600])
                              : null,
                        ),
                        SizedBox(height: screenSize.height * 0.01), // 1% của chiều cao màn hình
                        Text(
                          petName,
                          style: TextStyle(
                            fontSize: screenWidth * 0.06, // 6% của chiều rộng màn hình
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                CategoryText(title: 'Đặt dịch vụ'),
                SizedBox(height: screenSize.height * 0.02),

                // Sử dụng LayoutBuilder để xây dựng UI dựa trên không gian có sẵn
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Tính toán chiều rộng cho mỗi BoxText dựa trên chiều rộng có sẵn
                    // Đổi từ Row cứng thành bố cục linh hoạt với Wrap
                    return Wrap(
                      spacing: constraints.maxWidth * 0.05, // khoảng cách ngang
                      runSpacing: screenSize.height * 0.02, // khoảng cách dọc
                      alignment: WrapAlignment.start,
                      children: [
                        SizedBox(
                          width: (constraints.maxWidth - constraints.maxWidth * 0.05) / 2, // 2 item mỗi hàng
                          child: BoxText(
                            title: 'Vắc xin',
                            icon: Icons.vaccines,
                            onTap: () {
                              AppNavigator.push(context, ChoiceServicePage(petName: petName, petId: petId, petSpecies: petSpecies,));
                            }
                          ),
                        ),
                        SizedBox(
                          width: (constraints.maxWidth - constraints.maxWidth * 0.05) / 2,
                          child: BoxText(
                            title: 'Microchip',
                            icon: Icons.qr_code,
                            onTap: () {}
                          ),
                        ),
                        SizedBox(
                          width: (constraints.maxWidth - constraints.maxWidth * 0.05) / 2,
                          child: BoxText(
                            title: 'Chứng nhận sức khỏe',
                            icon: Icons.book,
                            onTap: () {}
                          ),
                        ),
                      ],
                    );
                  }
                ),

                SizedBox(height: screenSize.height * 0.02),
                CategoryText(title: 'Sổ ghi chép'),
                SizedBox(height: screenSize.height * 0.02),

                // Sử dụng LayoutBuilder cho phần Sổ ghi chép
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Wrap(
                      spacing: constraints.maxWidth * 0.05,
                      runSpacing: screenSize.height * 0.02,
                      alignment: WrapAlignment.start,
                      children: [
                        SizedBox(
                          width: (constraints.maxWidth - constraints.maxWidth * 0.05) / 2,
                          child: BoxText(
                            title: 'Vắc xin',
                            icon: Icons.vaccines,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(
                          width: (constraints.maxWidth - constraints.maxWidth * 0.05) / 2,
                          child: BoxText(
                            title: 'Microchip',
                            icon: Icons.qr_code,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(
                          width: (constraints.maxWidth - constraints.maxWidth * 0.05) / 2, // 3 items mỗi hàng
                          child: BoxText(
                            title: 'Chứng nhận sức khỏe',
                            icon: Icons.book,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(
                          width: (constraints.maxWidth - constraints.maxWidth * 0.05) / 2,
                          child: BoxText(
                            title: 'Lịch gợi ý',
                            icon: Icons.calendar_month,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(
                          width: (constraints.maxWidth - constraints.maxWidth * 0.05) / 2,
                          child: BoxText(
                            title: 'Cẩm nang',
                            icon: Icons.tips_and_updates,
                            onTap: () {},
                          ),
                        ),
                      ],
                    );
                  }
                ),

                SizedBox(height: screenSize.height * 0.02),

                CategoryText(title: 'Thông tin thú cưng'),

                SizedBox(height: screenSize.height * 0.02),

                LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      // Tính toán chiều rộng cho mỗi BoxText dựa trên chiều rộng có sẵn
                      // Đổi từ Row cứng thành bố cục linh hoạt với Wrap
                      return Wrap(
                        spacing: constraints.maxWidth * 0.05, // khoảng cách ngang
                        runSpacing: screenSize.height * 0.02, // khoảng cách dọc
                        alignment: WrapAlignment.start,
                        children: [
                          SizedBox(
                            width: (constraints.maxWidth - constraints.maxWidth * 0.05) / 2,
                            child: BoxText(
                              title: 'Thông tin',
                              icon: Icons.medical_information,
                              onTap: () {},
                            ),
                          ),
                          SizedBox(
                            width: (constraints.maxWidth - constraints.maxWidth * 0.05) / 2,
                            child: BoxText(
                              title: 'Hồ sơ tiêm chủng',
                              icon: Icons.emergency_recording,
                              onTap: () {},
                            ),
                          ),
                        ],
                      );
                    }
                ),

                SizedBox(height: screenSize.height * 0.05),
              ],
            )
          ),
        )
      )
    );
  }
 }
