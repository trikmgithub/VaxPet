import 'package:flutter/material.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/common/widgets/reactive_button/reactive_button.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:dartz/dartz.dart';

import '../../../common/helper/message/display_message.dart';
import '../../../domain/auth/usecases/logout.dart';
import '../../../service_locator.dart';
import '../../address_vax_pet/pages/address_vax_pet.dart';
import '../../buy_history/pages/buy_history.dart';
import '../../help/pages/help.dart';
import '../../membership/pages/membership.dart';
import '../../password/pages/reset_password.dart';
import '../../splash/pages/introduce.dart';
import 'customer_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình để thiết kế responsive
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        // Tắt padding top của SafeArea để loại bỏ khoảng trắng trên cùng
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Phần header với avatar và thông tin cơ bản
              _buildProfileHeader(context),
              // Phần menu tùy chọn
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 12),
                      child: Text(
                        'Tài khoản của bạn',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    _buildMenuCard(context, [
                      _buildMenuItem(
                        context,
                        'Thông tin cá nhân',
                        Icons.person_outline,
                        () => AppNavigator.push(context, const CustomerProfilePage()),
                      ),
                      const Divider(height: 1),
                      _buildMenuItem(
                        context,
                        'Hạng thành viên',
                        Icons.card_membership,
                        () => AppNavigator.push(context, const MembershipPage()),
                      ),
                      const Divider(height: 1),
                      _buildMenuItem(
                        context,
                        'Lịch sử mua hàng',
                        Icons.shopping_bag_outlined,
                        () => AppNavigator.push(context, const BuyHistoryPage()),
                      ),
                    ]),

                    const SizedBox(height: 24),

                    const Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 12),
                      child: Text(
                        'Cài đặt & Hỗ trợ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    _buildMenuCard(context, [
                      _buildMenuItem(
                        context,
                        'Địa chỉ VaxPet',
                        Icons.location_on_outlined,
                        () => AppNavigator.push(context, const AddressVaxPetPage()),
                      ),
                      const Divider(height: 1),
                      _buildMenuItem(
                        context,
                        'Đổi mật khẩu',
                        Icons.lock_outline,
                        () => AppNavigator.push(context, const ResetPasswordPage()),
                      ),
                      const Divider(height: 1),
                      _buildMenuItem(
                        context,
                        'Hỗ trợ',
                        Icons.help_outline,
                        () => AppNavigator.push(context, const HelpPage()),
                      ),
                    ]),

                    const SizedBox(height: 32),

                    // Nút đăng xuất được thiết kế đẹp hơn
                    _buildLogoutButton(context),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget hiển thị header profile với avatar và thông tin
  Widget _buildProfileHeader(BuildContext context) {
    // Lấy kích thước màn hình để điều chỉnh UI responsive
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;

    return Container(
      width: double.infinity,
      // Sử dụng layout linh hoạt thay vì chiều cao cố định
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? screenSize.height * 0.02 : screenSize.height * 0.03,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar - kích thước tùy thuộc vào màn hình
            CircleAvatar(
              radius: isSmallScreen ? 38 : 42, // Giảm kích thước avatar một chút
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: isSmallScreen ? 35 : 39,
                backgroundColor: Colors.grey.shade200,
                child: Icon(
                  Icons.person,
                  size: isSmallScreen ? 38 : 44,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 14), // Giảm khoảng cách

            // Tên người dùng
            const Text(
              'Xin chào,',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Người dùng VaxPet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: isSmallScreen ? 5 : 6), // Giảm khoảng cách nếu màn hình nhỏ
            // Email container - sử dụng kích thước linh hoạt
            Container(
              margin: EdgeInsets.only(bottom: isSmallScreen ? 10 : 12),
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: isSmallScreen ? 3 : 5,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'user@example.com',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 12 : 13,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tạo menu item
  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[500],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // Widget tạo card cho menu
  Widget _buildMenuCard(BuildContext context, List<Widget> children) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // Widget nút đăng xuất
  Widget _buildLogoutButton(BuildContext context) {
    return ReactiveButton(
      title: 'Đăng xuất',
      activeColor: Colors.red.shade400,
      onPressed: () async {
        try {
          await sl<LogoutUseCase>().call(params: null);
          return const Right('success');
        } catch (e) {
          return Left(e.toString());
        }
      },
      onSuccess: () {
        AppNavigator.pushAndRemove(context, IntroducePage());
      },
      onFailure: (error) {
        DisplayMessage.errorMessage(error.toString(), context);
      },
    );
  }
}
