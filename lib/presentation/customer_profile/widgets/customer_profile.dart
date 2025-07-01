import 'package:flutter/material.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/domain/customer_profile/entities/customer_profile.dart';

import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../pages/customer_profile_edit.dart';

class CustomerProfile extends StatelessWidget {
  final CustomerProfileEntity customerProfile;
  const CustomerProfile({super.key, required this.customerProfile});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      appBar: BasicAppbar(
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildImagePicker(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? screenSize.width * 0.1 : 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Section: Chi tiết thêm
                      _buildSectionTitle('Thông tin tài khoản', Icons.description),

                      _buildCard([
                        _buildEmailField(),
                      ]),

                      const SizedBox(height: 16),

                      // Section: Thông tin cơ bản
                      _buildSectionTitle('Thông tin cơ bản', Icons.info),

                      _buildCard([
                        _buildNameField(),
                        const SizedBox(height: 16),
                        _buildNickNameField(),
                        const SizedBox(height: 16),
                        _buildGenderField(),
                        const SizedBox(height: 16),
                        _buildBirthdayField(),
                        const SizedBox(height: 16),
                        _buildPhoneNumberField(),
                      ]),

                      const SizedBox(height: 16),

                      // Section: Thông tin nơi ở
                      _buildSectionTitle('Thông tin nơi ở', Icons.home),
                      _buildCard([
                        _buildAddressField(),
                      ]),

                    ],
                  ),
                ),
                _buildButtonEdit(context),
                const SizedBox(height: 50),
              ]
            ),
          ),
        )
      )
    );
  }

  // Widget để tạo card chứa các trường
  Widget _buildCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  // Widget để tạo tiêu đề section
  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,  // Thay đổi từ start sang center
      children: [
        const Text(
          'Hình ảnh của bạn',
          style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),  // Thêm khoảng cách giữa text và vòng tròn
        CircleAvatar(
          radius: 50,  // Kích thước vòng tròn
          backgroundColor: Colors.grey.shade300,  // Màu nền của vòng tròn
          child: customerProfile.image != null && customerProfile.image!.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    customerProfile.image!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(Icons.person, size: 50, color: Colors.grey.shade600),  // Biểu tượng người dùng nếu không có ảnh
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      readOnly: true,
      initialValue: customerProfile.email?.trim(),
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: Icon(Icons.person, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      readOnly: true,
      initialValue: customerProfile.fullName?.trim(),
      decoration: InputDecoration(
        labelText: 'Họ và tên',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: Icon(Icons.person, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildNickNameField() {
    return TextFormField(
      readOnly: true,
      initialValue: customerProfile.userName?.trim(),
      decoration: InputDecoration(
        labelText: 'Tên hiển thị',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: Icon(Icons.account_box, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildGenderField() {
    return TextFormField(
      readOnly: true,
      initialValue: customerProfile.gender?.trim(),
      decoration: InputDecoration(
        labelText: 'Giới tính',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: Icon(Icons.wc, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildBirthdayField() {
    return TextFormField(
      readOnly: true,
      initialValue: customerProfile.dateOfBirth?.trim(),
      decoration: InputDecoration(
        labelText: 'Ngày sinh',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: Icon(Icons.cake_outlined, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      readOnly: true,
      initialValue: customerProfile.phoneNumber?.trim(),
      decoration: InputDecoration(
        labelText: 'Số điện thoại',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: Icon(Icons.phone, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      readOnly: true,
      initialValue: customerProfile.address?.trim(),
      decoration: InputDecoration(
        labelText: 'Địa chỉ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildButtonEdit(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          AppNavigator.push(context, CustomerProfileEditPage(
            accountId: customerProfile.accountId,
            customerProfile: customerProfile,
            email: customerProfile.email?.trim(),
            customerId: customerProfile.customerId,
          ));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          elevation: 2,
        ),
        child: const Text(
          'Chỉnh sửa',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }



}
