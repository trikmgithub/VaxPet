import 'package:flutter/material.dart';
import 'package:vaxpet/common/widgets/back_button/back_button.dart';
import '../../../common/helper/navigation/app_navigation.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../appointment_microchip/pages/appointment_microchip_clinic.dart';

class AppointmentHealthCertificateChoicePage extends StatelessWidget {
  final String petName;
  final int petId;
  final String petSpecies;
  const AppointmentHealthCertificateChoicePage({super.key, required this.petName, required this.petId, required this.petSpecies});

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình để tính toán responsive
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final bool isTablet = screenWidth > 600;

    // Tính toán padding dựa trên kích thước màn hình
    final double horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button ở góc trái trên cùng
              Container(
                alignment: Alignment.topLeft,
                child: BackButtonBasic(),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Tiêu đề trang
              Center(
                child: SizedBox(
                  width: isTablet ? screenWidth * 0.7 : screenWidth * 0.85,
                  child: Text(
                    'Tiếp tục đặt lịch cấp giấy chứng nhận sức khỏe cho $petName',
                    style: TextStyle(
                      fontSize: isTablet ? 28 : 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.06),

              // Container cho phần lựa chọn dịch vụ
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    // Tùy chọn tiêm tại trung tâm
                    _buildServiceOption(
                      context: context,
                      title: 'Thực hiện tại trung tâm',
                      description: 'Đặt lịch cấp giấy chứng nhận sức khỏe tại trung tâm của chúng tôi',
                      icon: Icons.local_hospital_rounded,
                      color: Colors.green[700]!,
                      isTablet: isTablet,
                      onTap: () {
                        AppNavigator.push(
                          context,
                          AppointmentMicrochipClinicPage(
                            petName: petName,
                            petId: petId,
                            petSpecies: petSpecies,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              // Phần thông tin bổ sung
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700], size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Lưu ý',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Lịch hẹn sẽ được xác nhận sau khi đặt thành công. Bạn có thể xem và quản lý lịch hẹn trong mục "Sổ ghi chép".',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget tùy chọn dịch vụ với thiết kế đẹp và hỗ trợ responsive
  Widget _buildServiceOption({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool isTablet,
    required VoidCallback onTap,
  }) {

    return SizedBox(
      width: double.infinity,
      height: isTablet ? 130 : 110,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: color.withValues(alpha: 0.1),
          highlightColor: color.withValues(alpha: 0.05),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon section
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 30,
                      color: color,
                    ),
                  ),
                ),

                SizedBox(width: 16),

                // Text section
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          color: Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
