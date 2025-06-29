import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaxpet/common/widgets/app_bar/app_bar.dart';
import 'package:vaxpet/common/widgets/reactive_button/reactive_button.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/data/customer_profile/models/customer_profile.dart';

import '../../../common/helper/message/display_message.dart';
import '../../../data/auth/models/signin_req_params.dart';
import '../../../domain/auth/usecases/signin.dart';
import '../../../domain/customer_profile/usecases/put_customer_profile.dart';
import '../../../service_locator.dart';

class CustomerProfileEditPage extends StatefulWidget {
  final int? accountId;
  const CustomerProfileEditPage({super.key, this.accountId});

  @override
  State<CustomerProfileEditPage> createState() => _CustomerProfileEditPageState();
}

class _CustomerProfileEditPageState extends State<CustomerProfileEditPage> {
  bool? hideBackButton;
  String? email;
  int? customerId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();
  final TextEditingController _houseNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String? _selectedGender;
  final ImagePicker _picker = ImagePicker();
  File? image;

  @override
  void initState() {
    super.initState();
    _initializeHideBackButton();
  }

  Future<void> _initializeHideBackButton() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? emailPref = sharedPreferences.getString('email');
    final int? customerIdPref = sharedPreferences.getInt('customerId');

    setState(() {
      email = emailPref!;
      customerId = customerIdPref!;
      hideBackButton = sharedPreferences.getString('address') != '' ? false : false;
    });

  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    // Giải phóng các controller khi widget bị hủy
    _nameController.dispose();
    _userNameController.dispose();
    _dateOfBirthController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _wardController.dispose();
    _houseNameController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình để điều chỉnh giao diện responsive
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      appBar: BasicAppbar(
        hideBack: hideBackButton!,
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
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
              children: [
                // Header với phần chọn ảnh - đã đổi sang màu nền trắng
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
                      // Tiêu đề section với icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_camera,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Thêm ảnh cá nhân',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _buildImagePicker(),
                    ],
                  ),
                ),

                // Form thông tin
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
                        _buildDateOfBirthField(),
                        const SizedBox(height: 16),
                        _buildPhoneNumberField(),
                      ]),
                      const SizedBox(height: 16),

                      // Section: Thông tin nơi ở
                      _buildSectionTitle('Thông tin nơi ở', Icons.home),
                      _buildCard([
                        _buildCityField(),
                        const SizedBox(height: 16),
                        _buildDistrictField(),
                        const SizedBox(height: 16),
                        _buildWardField(),
                        const SizedBox(height: 16),
                        _buildHouseNameField(),
                      ]),

                      const SizedBox(height: 30),

                      // Button submit
                      _buildSubmitButton(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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


  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Họ và tên *',
        hintText: 'Nhập họ và tên',
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
      textCapitalization: TextCapitalization.words, // Tự động viết hoa chữ cái đầu mỗi từ
    );
  }

  Widget _buildNickNameField() {
    return TextFormField(
      controller: _userNameController,
      decoration: InputDecoration(
        labelText: 'Tên hiển thị *',
        hintText: 'Nhập tên hiển thị',
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
      textCapitalization: TextCapitalization.words, // Tự động viết hoa chữ cái đầu mỗi từ
    );
  }

  Widget _buildDropdownItem(IconData icon, Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16), // Reduced icon size from 20 to 16
        const SizedBox(width: 6), // Reduced spacing from 10 to 6
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Giới tính *',
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
        prefixIcon: Icon(Icons.filter_list, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      icon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
      dropdownColor: Colors.white,
      elevation: 2,
      isExpanded: true,
      value: _selectedGender,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng chọn giới tính';
        }
        return null;
      },
      items: [
        DropdownMenuItem<String>(
          value: 'Nam',
          child: _buildDropdownItem(Icons.male, Colors.blue, 'Nam'),
        ),
        DropdownMenuItem<String>(
          value: 'Nữ',
          child: _buildDropdownItem(Icons.female, Colors.pink, 'Nữ'),
        ),
      ],
      onChanged: (String? value) {
        setState(() {
          _selectedGender = value;
        });
      },
    );
  }

  Widget _buildDateOfBirthField() {
    return TextFormField(
      controller: _dateOfBirthController,
      decoration: InputDecoration(
        labelText: 'Ngày sinh *',
        hintText: 'Nhập ngày sinh thú cưng của bạn',
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
        suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      keyboardType: TextInputType.datetime,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.primary,
                ),
                dialogTheme: DialogThemeData(backgroundColor: Colors.white),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          // format date dd/mm/yyyy
          String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          _dateOfBirthController.text = formattedDate;
        }
      },
      readOnly: true,
    );
  }

  Widget _buildCityField() {
    return TextFormField(
      controller: _cityController,
      decoration: InputDecoration(
        labelText: 'Tỉnh / Thành phố *',
        hintText: 'Nhập tỉnh hoặc thành phố',
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
        prefixIcon: Icon(Icons.home_outlined, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      textCapitalization: TextCapitalization.sentences, // Tự động viết hoa chữ cái đầu mỗi từ
    );
  }

  Widget _buildDistrictField() {
    return TextFormField(
      controller: _districtController,
      decoration: InputDecoration(
        labelText: 'Quận / Huyện *',
        hintText: 'Nhập quận hoặc huyện',
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
        prefixIcon: Icon(Icons.home_outlined, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      textCapitalization: TextCapitalization.sentences, // Tự động viết hoa chữ cái đầu mỗi từ
    );
  }

  Widget _buildWardField() {
    return TextFormField(
      controller: _wardController,
      decoration: InputDecoration(
        labelText: 'Phường / Xã *',
        hintText: 'Nhập phường hoặc xã',
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
        prefixIcon: Icon(Icons.home_outlined, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      textCapitalization: TextCapitalization.sentences, // Tự động viết hoa chữ cái đầu mỗi từ
    );
  }

  Widget _buildHouseNameField() {
    return TextFormField(
      controller: _houseNameController,
      decoration: InputDecoration(
        labelText: 'Số nhà *',
        hintText: 'Nhập số nhà',
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
        prefixIcon: Icon(Icons.home_outlined, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      textCapitalization: TextCapitalization.sentences, // Tự động viết hoa chữ cái đầu mỗi từ
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,  // Thay đổi từ start sang center
      children: [
        const Text(
          'Hình ảnh của bạn',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 10),  // Thêm khoảng cách giữa text và vòng tròn
        Center(  // Bọc InkWell trong Center để đảm bảo căn giữa
          child: InkWell(
            onTap: _pickImage,
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,  // Đảm bảo ảnh được cắt theo hình tròn
              child: image != null
                  ? Image.file(image!, fit: BoxFit.cover)
                  : const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),  // Thêm padding cho text
                  child: Text(
                    'Chạm để chọn ảnh',
                    style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,  // Đảm bảo text được căn giữa
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      controller: _phoneNumberController,
      decoration: InputDecoration(
        labelText: 'Số điện thoại *',
        hintText: 'Nhập số điện thoại',
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
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      readOnly: true,
      initialValue: '$email',
      decoration: InputDecoration(
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
        prefixIcon: Icon(Icons.email, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ReactiveButton(
        title: 'Cập nhật',
        activeColor: AppColors.primary,
        onPressed: () async => sl<PutCustomerProfileUseCase>().call(
          params: CustomerProfileModel(
            customerId: customerId,
            fullName: _nameController.text,
            userName: _userNameController.text,
            image: image != null ? image!.path : null,
            phoneNumber: _phoneNumberController.text,
            dateOfBirth: _dateOfBirthController.text,
            gender: _selectedGender,
            address: _cityController.text +
                     ', ' + _districtController.text +
                     ', ' + _wardController.text +
                     ', ' + _houseNameController.text,

          )
        ),
        onSuccess: () {
          DisplayMessage.successMessage('Cập nhật thông tin thành công', context);
          Navigator.of(context).pop();
        },
        onFailure: (error) {
          DisplayMessage.errorMessage(error, context);
        }
    );
  }
}
