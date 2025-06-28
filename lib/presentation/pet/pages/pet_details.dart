import 'package:flutter/material.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';

import '../../../common/widgets/back_button/back_button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../appointment_microchip/pages/appointment_microchip_choice.dart';
import '../../vaccine_appointment_note/pages/vaccine_appointment_note.dart';
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
    final double screenHeight = screenSize.height;

    // Tính toán padding dựa trên chiều rộng màn hình - responsive
    final double horizontalPadding = screenWidth * 0.04;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Positioning back button at the top-left corner
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: screenHeight * 0.01,
                  left: horizontalPadding,
                ),
                child: BackButtonBasic(),
              ),
        
              // Pet Profile Section with avatar on top
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: screenHeight * 0.01,
                      bottom: screenHeight * 0.02,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 12,
                                spreadRadius: 2,
                                offset: Offset(0, 2)
                              )
                            ],
                          ),
                          child: Hero(
                            tag: 'pet-$petId',
                            child: CircleAvatar(
                              radius: isTablet ? screenWidth * 0.08 : screenWidth * 0.12,
                              backgroundColor: Colors.white,
                              backgroundImage: petImage != null && petImage!.isNotEmpty
                                  ? NetworkImage(petImage!)
                                  : null,
                              child: petImage == null || petImage!.isEmpty
                                  ? Icon(
                                      Icons.pets,
                                      size: isTablet ? screenWidth * 0.08 : screenWidth * 0.10,
                                      color: Colors.grey[600]
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Text(
                          petName,
                          style: TextStyle(
                            fontSize: isTablet ? screenWidth * 0.04 : screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          petSpecies,
                          style: TextStyle(
                            fontSize: isTablet ? screenWidth * 0.025 : screenWidth * 0.035,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        
              // Services Card Section
              _buildSectionCard(
                context,
                title: 'Đặt dịch vụ',
                child: _buildServiceGrid(
                  context,
                  [
                    ServiceItem(
                      title: 'Vắc xin',
                      icon: Icons.vaccines,
                      onTap: () {
                        AppNavigator.push(context, ChoiceServicePage(
                          petName: petName,
                          petId: petId,
                          petSpecies: petSpecies,
                        ));
                      },
                    ),
                    ServiceItem(
                      title: 'Microchip',
                      icon: Icons.qr_code,
                      onTap: () {
                        AppNavigator.push(context, AppointmentMicrochipChoicePage(
                          petName: petName,
                          petId: petId,
                          petSpecies: petSpecies,
                        ));
                      },
                    ),
                    ServiceItem(
                      title: 'Chứng nhận sức khỏe',
                      icon: Icons.book,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
        
              SizedBox(height: screenHeight * 0.02),
        
              // Pet Records Card Section
              _buildSectionCard(
                context,
                title: 'Sổ ghi chép',
                child: _buildServiceGrid(
                  context,
                  [
                    ServiceItem(
                      title: 'Vắc xin',
                      icon: Icons.vaccines,
                      onTap: () {
                        AppNavigator.push(context, VaccineAppointmentNotePage(
                          petName: petName,
                          petId: petId,
                          petSpecies: petSpecies,
                        ));
                      },
                    ),
                    ServiceItem(
                      title: 'Microchip',
                      icon: Icons.qr_code,
                      onTap: () {},
                    ),
                    ServiceItem(
                      title: 'Chứng nhận sức khỏe',
                      icon: Icons.book,
                      onTap: () {},
                    ),
                    ServiceItem(
                      title: 'Lịch gợi ý',
                      icon: Icons.calendar_month,
                      onTap: () {},
                    ),
                    ServiceItem(
                      title: 'Cẩm nang',
                      icon: Icons.tips_and_updates,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
        
              SizedBox(height: screenHeight * 0.02),
        
              // Pet Info Card Section
              _buildSectionCard(
                context,
                title: 'Thông tin thú cưng',
                child: _buildServiceGrid(
                  context,
                  [
                    ServiceItem(
                      title: 'Thông tin',
                      icon: Icons.medical_information,
                      onTap: () {},
                    ),
                    ServiceItem(
                      title: 'Hồ sơ tiêm chủng',
                      icon: Icons.emergency_recording,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
        
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build section cards with a consistent design
  Widget _buildSectionCard(BuildContext context, {required String title, required Widget child}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.04,
              screenHeight * 0.02,
              screenWidth * 0.04,
              screenHeight * 0.01
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: screenWidth > 600 ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: child,
          ),
        ],
      ),
    );
  }

  // Helper method to build a responsive service grid
  Widget _buildServiceGrid(BuildContext context, List<ServiceItem> items) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final gridCount = isTablet ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridCount,
        childAspectRatio: isTablet ? 1.5 : 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildServiceItem(context, item);
      },
    );
  }

  // Helper method to build a service item with consistent design
  Widget _buildServiceItem(BuildContext context, ServiceItem item) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final iconSize = isTablet ? screenWidth * 0.04 : screenWidth * 0.06;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: iconSize,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 8),
            Text(
              item.title,
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class to store service item data
class ServiceItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  ServiceItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
