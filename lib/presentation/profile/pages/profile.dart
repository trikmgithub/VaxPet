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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản'),
        centerTitle: true,
        backgroundColor: AppColors.primary, // Thêm màu nền cho AppBar
        titleTextStyle: const TextStyle(
          color:
              Colors
                  .white, // Thay đổi màu chữ thành trắng để tương phản với nền
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        // Thêm các icon cũng có màu trắng
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _editCustomerInfo(context),
              const SizedBox(height: 4),
              _membership(context),
              const SizedBox(height: 4),
              _historyBuy(context),
              const SizedBox(height: 4),
              _addressVaxPet(context),
              const SizedBox(height: 4),
              _help(context),
              const SizedBox(height: 4),
              _setPassword(context),
              const SizedBox(height: 16),
              _buttonLogout(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editCustomerInfo(BuildContext context) {
    return SizedBox(
      width:
          double
              .infinity, // Đảm bảo nút có chiều ngang bằng với chiều ngang của màn hình
      child: TextButton(
        onPressed: () {
          AppNavigator.push(context, const CustomerProfilePage());
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ), // Thêm padding để nút có chiều cao đẹp hơn
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Để text ở trái và icon ở phải
          children: [
            const Text(
              'Thông tin cá nhân',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _membership(BuildContext context) {
    return SizedBox(
      width:
          double
              .infinity, // Đảm bảo nút có chiều ngang bằng với chiều ngang của màn hình
      child: TextButton(
        onPressed: () {
          AppNavigator.push(context, const MembershipPage());
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ), // Thêm padding để nút có chiều cao đẹp hơn
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Để text ở trái và icon ở phải
          children: [
            const Text(
              'Hạng thành viên',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _historyBuy(BuildContext context) {
    return SizedBox(
      width:
          double
              .infinity, // Đảm bảo nút có chiều ngang bằng với chiều ngang của màn hình
      child: TextButton(
        onPressed: () {
          AppNavigator.push(context, const BuyHistoryPage());
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ), // Thêm padding để nút có chiều cao đẹp hơn
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Để text ở trái và icon ở phải
          children: [
            const Text(
              'Lịch sử mua hàng',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _addressVaxPet(BuildContext context) {
    return SizedBox(
      width:
          double
              .infinity, // Đảm bảo nút có chiều ngang bằng với chiều ngang của màn hình
      child: TextButton(
        onPressed: () {
          AppNavigator.push(context, const AddressVaxPetPage());
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ), // Thêm padding để nút có chiều cao đẹp hơn
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Để text ở trái và icon ở phải
          children: [
            const Text(
              'Địa chỉ VaxPet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _help(BuildContext context) {
    return SizedBox(
      width:
          double
              .infinity, // Đảm bảo nút có chiều ngang bằng với chiều ngang của màn hình
      child: TextButton(
        onPressed: () {
          AppNavigator.push(context, const HelpPage());
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ), // Thêm padding để nút có chiều cao đẹp hơn
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Để text ở trái và icon ở phải
          children: [
            const Text(
              'Hỗ trợ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _setPassword(BuildContext context) {
    return SizedBox(
      width:
          double
              .infinity, // Đảm bảo nút có chiều ngang bằng với chiều ngang của màn hình
      child: TextButton(
        onPressed: () {
          AppNavigator.push(context, const ResetPasswordPage());
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ), // Thêm padding để nút có chiều cao đẹp hơn
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Để text ở trái và icon ở phải
          children: [
            const Text(
              'Đổi mật khẩu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buttonLogout(BuildContext context) {
    return ReactiveButton(
      title: 'Đăng xuất',
      activeColor: AppColors.primary,
      onPressed: () async {
        try {
          await sl<LogoutUseCase>().call(params: null);
          // Trả về Either.Right khi thành công
          return Right('success');
        } catch (e) {
          // Trả về Either.Left khi thất bại
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
