import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:vaxpet/common/widgets/app_bar/app_bar.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/data/customer_profile/models/customer_profile.dart';
import 'package:vaxpet/domain/customer_profile/entities/customer_profile.dart';
import '../../../common/helper/message/display_message.dart';
import '../../../domain/customer_profile/usecases/put_customer_profile.dart';
import '../../../service_locator.dart';

class CustomerProfileEditPage extends StatefulWidget {
  final int? accountId;
  final String? email;
  final int? customerId;
  final CustomerProfileEntity? customerProfile;
  const CustomerProfileEditPage({
    super.key,
    this.accountId,
    this.customerProfile,
    this.email,
    this.customerId,
  });

  @override
  State<CustomerProfileEditPage> createState() =>
      _CustomerProfileEditPageState();
}

class _CustomerProfileEditPageState extends State<CustomerProfileEditPage> {
  bool? hideBackButton;
  int? customerId;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _wardController = TextEditingController();
  TextEditingController _houseNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  String? _selectedGender;
  final ImagePicker _picker = ImagePicker();
  String? imageUrl; // Changed from File? image to String? imageUrl
  bool _isCommitmentChecked = false;
  bool _isLoading = false; // Thêm biến loading state

  late FocusNode _nameFocusNode;
  late FocusNode _userNameFocusNode;
  late FocusNode _phoneNumberFocusNode;
  late FocusNode _dateOfBirthFocusNode;
  late FocusNode _cityFocusNode;
  late FocusNode _districtFocusNode;
  late FocusNode _wardFocusNode;
  late FocusNode _houseNameFocusNode;

  @override
  void initState() {
    super.initState();
    _initializeCustomerId();
    _initializeHideBackButton();
    _nameFocusNode = FocusNode();
    _userNameFocusNode = FocusNode();
    _phoneNumberFocusNode = FocusNode();
    _dateOfBirthFocusNode = FocusNode();
    _cityFocusNode = FocusNode();
    _districtFocusNode = FocusNode();
    _wardFocusNode = FocusNode();
    _houseNameFocusNode = FocusNode();
    _emailController = TextEditingController(text: widget.email);
    _nameController = TextEditingController(
      text: widget.customerProfile?.fullName ?? '',
    );
    _userNameController = TextEditingController(
      text: widget.customerProfile?.userName ?? '',
    );
    if (widget.customerProfile?.gender != null) {
      _selectedGender = _convertGenderToVietnamese(widget.customerProfile?.gender);
    }
    if (widget.customerProfile?.image != null) {
      imageUrl = widget.customerProfile!.image!;
    }
    _dateOfBirthController = TextEditingController(
      text: widget.customerProfile?.dateOfBirth ?? '',
    );
    _phoneNumberController = TextEditingController(
      text: widget.customerProfile?.phoneNumber ?? '',
    );
    _cityController = TextEditingController(
      text: widget.customerProfile?.address?.split(', ').last ?? '',
    );
    _districtController = TextEditingController(
      text: widget.customerProfile?.address?.split(', ').elementAt(1) ?? '',
    );
    _wardController = TextEditingController(
      text: widget.customerProfile?.address?.split(', ').elementAt(2) ?? '',
    );
    _houseNameController = TextEditingController(
      text: widget.customerProfile?.address?.split(', ').first ?? '',
    );
  }

  Future<void> _initializeCustomerId() async {
    if (widget.customerId != null) {
      customerId = widget.customerId;
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      customerId = prefs.getInt('customerId');
    }
  }

  Future<void> _initializeHideBackButton() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    setState(() {
      hideBackButton =
          sharedPreferences.getString('address') != '' ? false : true;
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path;
      });
    }
  }

  // Function để lưu image vào cache directory
  Future<String?> _saveImageToCache(File imageFile) async {
    try {
      // Lấy cache directory
      final Directory cacheDir = await getApplicationCacheDirectory();

      // Tạo thư mục profile_images nếu chưa có
      final Directory profileImagesDir = Directory(
        '${cacheDir.path}/profile_images',
      );
      if (!await profileImagesDir.exists()) {
        await profileImagesDir.create(recursive: true);
      }

      // Tạo tên file unique với timestamp
      final String fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final String cachedImagePath = '${profileImagesDir.path}/$fileName';

      // Copy file vào cache directory
      final File cachedImage = await imageFile.copy(cachedImagePath);

      return cachedImage.path;
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _userNameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _dateOfBirthFocusNode.dispose();
    _cityFocusNode.dispose();
    _districtFocusNode.dispose();
    _wardFocusNode.dispose();
    _houseNameFocusNode.dispose();
    // Giải phóng các controller khi widget bị hủy
    _emailController.dispose();
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

    return WillPopScope(
      onWillPop: () async {
        // Nếu hideBackButton = true, không cho phép quay lại
        return !(hideBackButton ?? false);
      },
      child: Scaffold(
        appBar: BasicAppbar(
          hideBack: hideBackButton ?? false,
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
            decoration: BoxDecoration(color: Colors.grey[50]),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header với phần chọn ảnh - đã đổi sang màu nền trắng
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 20,
                    ),
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
                        _buildSectionTitle(
                          'Thông tin tài khoản',
                          Icons.description,
                        ),
                        _buildCard([_buildEmailField()]),
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

                        // Commitment checkbox
                        _buildCommitmentCheckbox(),
                        const SizedBox(height: 20),

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
      ),
    );
  }

  // Widget để tạo tiêu đề section
  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
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
      focusNode: _nameFocusNode,
      decoration: InputDecoration(
        labelText: 'Họ và tên *',
        hintText: 'Nhập họ và tên',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      textCapitalization:
          TextCapitalization.words, // Tự động viết hoa chữ cái đầu mỗi từ
    );
  }

  Widget _buildNickNameField() {
    return TextFormField(
      controller: _userNameController,
      focusNode: _userNameFocusNode,
      decoration: InputDecoration(
        labelText: 'Tên hiển thị *',
        hintText: 'Nhập tên hiển thị',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      textCapitalization:
          TextCapitalization.words, // Tự động viết hoa chữ cái đầu mỗi t��
    );
  }

  Widget _buildDropdownItem(IconData icon, Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16), // Reduced icon size from 20 to 16
        const SizedBox(width: 6), // Reduced spacing from 10 to 6
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Giới tính *',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                colorScheme: ColorScheme.light(primary: AppColors.primary),
                dialogTheme: DialogThemeData(backgroundColor: Colors.white),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          // format date dd/mm/yyyy
          String formattedDate =
              "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
          _dateOfBirthController.text = formattedDate;
        }
      },
      readOnly: true,
    );
  }

  Widget _buildCityField() {
    return TextFormField(
      controller: _cityController,
      focusNode: _cityFocusNode,
      decoration: InputDecoration(
        labelText: 'Tỉnh / Thành phố *',
        hintText: 'Nhập tỉnh hoặc thành phố',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      textCapitalization:
          TextCapitalization.sentences, // Tự động viết hoa chữ cái đầu mỗi từ
    );
  }

  Widget _buildDistrictField() {
    return TextFormField(
      controller: _districtController,
      focusNode: _districtFocusNode,
      decoration: InputDecoration(
        labelText: 'Quận / Huyện *',
        hintText: 'Nhập quận hoặc huyện',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      textCapitalization:
          TextCapitalization.sentences, // Tự động viết hoa chữ cái đầu mỗi từ
    );
  }

  Widget _buildWardField() {
    return TextFormField(
      controller: _wardController,
      focusNode: _wardFocusNode,
      decoration: InputDecoration(
        labelText: 'Phường / Xã *',
        hintText: 'Nhập phường hoặc xã',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      textCapitalization:
          TextCapitalization.sentences, // Tự động viết hoa chữ cái đầu mỗi từ
    );
  }

  Widget _buildHouseNameField() {
    return TextFormField(
      controller: _houseNameController,
      focusNode: _houseNameFocusNode,
      decoration: InputDecoration(
        labelText: 'Số nhà *',
        hintText: 'Nhập số nhà',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      textCapitalization:
          TextCapitalization.sentences, // Tự động viết hoa chữ cái đầu mỗi từ
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.center, // Thay đổi từ start sang center
      children: [
        const Text(
          'Hình ảnh của bạn',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 10), // Thêm khoảng cách giữa text và vòng tròn
        Center(
          // Bọc InkWell trong Center để đảm bảo căn giữa
          child: _buildImage(),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          shape: BoxShape.circle,
        ),
        clipBehavior: Clip.antiAlias, // Đảm bảo ảnh được cắt theo hình tròn
        child:
            imageUrl != null
                ? (imageUrl!.startsWith('http')
                    ? Image.network(imageUrl!, fit: BoxFit.cover)
                    : Image.file(File(imageUrl!), fit: BoxFit.cover))
                : const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0), // Thêm padding cho text
                    child: Text(
                      'Chạm để chọn ảnh',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center, // Đảm bảo text được căn giữa
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      controller: _phoneNumberController,
      focusNode: _phoneNumberFocusNode,
      decoration: InputDecoration(
        labelText: 'Số điện thoại *',
        hintText: 'Nhập số điện thoại',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      controller: _emailController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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

  Widget _buildCommitmentCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _isCommitmentChecked,
          onChanged: (bool? value) {
            setState(() {
              _isCommitmentChecked = value ?? false;
            });
          },
          activeColor: AppColors.primary,
        ),
        Expanded(
          child: Text(
            'Tôi cam kết thông tin trên là chính xác',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed:
          _isLoading
              ? null
              : () async {
                if (_nameController.text.trim().isEmpty) {
                  DisplayMessage.errorMessage(
                    'Vui lòng điền họ và tên',
                    context,
                  );
                  FocusScope.of(context).requestFocus(_nameFocusNode);
                  return;
                }
                if (_userNameController.text.trim().isEmpty) {
                  DisplayMessage.errorMessage(
                    'Vui lòng điền tên hiển thị',
                    context,
                  );
                  FocusScope.of(context).requestFocus(_userNameFocusNode);
                  return;
                }
                if (_phoneNumberController.text.trim().isEmpty) {
                  DisplayMessage.errorMessage(
                    'Vui lòng điền số điện thoại',
                    context,
                  );
                  FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
                  return;
                }
                if (_dateOfBirthController.text.trim().isEmpty) {
                  DisplayMessage.errorMessage(
                    'Vui lòng điền ngày sinh',
                    context,
                  );
                  FocusScope.of(context).requestFocus(_dateOfBirthFocusNode);
                  return;
                }
                if (_selectedGender == null || _selectedGender!.isEmpty) {
                  DisplayMessage.errorMessage(
                    'Vui lòng chọn giới tính',
                    context,
                  );
                  return;
                }
                if (_cityController.text.trim().isEmpty) {
                  DisplayMessage.errorMessage(
                    'Vui lòng điền tỉnh/thành phố',
                    context,
                  );
                  FocusScope.of(context).requestFocus(_cityFocusNode);
                  return;
                }
                if (_districtController.text.trim().isEmpty) {
                  DisplayMessage.errorMessage(
                    'Vui lòng điền quận/huyện',
                    context,
                  );
                  FocusScope.of(context).requestFocus(_districtFocusNode);
                  return;
                }
                if (_wardController.text.trim().isEmpty) {
                  DisplayMessage.errorMessage(
                    'Vui lòng điền phường/xã',
                    context,
                  );
                  FocusScope.of(context).requestFocus(_wardFocusNode);
                  return;
                }
                if (_houseNameController.text.trim().isEmpty) {
                  DisplayMessage.errorMessage('Vui lòng điền số nhà', context);
                  FocusScope.of(context).requestFocus(_houseNameFocusNode);
                  return;
                }
                if (!_isCommitmentChecked) {
                  DisplayMessage.errorMessage(
                    'Vui lòng xác nhận cam kết thông tin',
                    context,
                  );
                  return;
                }

                setState(() {
                  _isLoading = true;
                });

                try {
                  final result = await sl<PutCustomerProfileUseCase>().call(
                    params: CustomerProfileModel(
                      customerId: customerId,
                      fullName: _nameController.text.trim(),
                      userName: _userNameController.text.trim(),
                      image:
                          (imageUrl != null && !imageUrl!.startsWith('http'))
                              ? imageUrl
                              : null,
                      phoneNumber: _phoneNumberController.text.trim(),
                      dateOfBirth: _dateOfBirthController.text.trim(),
                      gender: _convertGenderToEnglish(_selectedGender),
                      address:
                          '${_houseNameController.text.trim()}, ${_wardController.text.trim()}, ${_districtController.text.trim()}, ${_cityController.text.trim()}',
                    ),
                  );

                  // Kiểm tra kết quả Either trước khi hiển thị thông báo
                  result.fold(
                    (error) {
                      // Trường hợp lỗi - hiển thị thông báo lỗi
                      if (mounted) {
                        DisplayMessage.errorMessage(error.toString(), context);
                      }
                    },
                    (data) async {
                      // Trường hợp thành công - lưu thông tin và hiển thị thông báo thành công
                      if (mounted) {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        final address =
                            '${_houseNameController.text.trim()}, ${_wardController.text.trim()}, ${_districtController.text.trim()}, ${_cityController.text.trim()}';
                        await prefs.setString('address', address);

                        if (imageUrl != null && !imageUrl!.startsWith('http')) {
                          final String? cachedImagePath = await _saveImageToCache(
                            File(imageUrl!),
                          );
                          if (cachedImagePath != null) {
                            await prefs.setString('profileImage', cachedImagePath);
                          }
                        }

                        await prefs.setString(
                          'fullName',
                          _nameController.text.trim(),
                        );
                        await prefs.setString(
                          'userName',
                          _userNameController.text.trim(),
                        );
                        await prefs.setString(
                          'phoneNumber',
                          _phoneNumberController.text.trim(),
                        );
                        await prefs.setString(
                          'dateOfBirth',
                          _dateOfBirthController.text.trim(),
                        );
                        if (_selectedGender != null) {
                          await prefs.setString('gender', _selectedGender!);
                        }

                        // Chỉ hiển thị thông báo thành công khi thực sự thành công
                        DisplayMessage.successMessage(
                          'Cập nhật thông tin thành công',
                          context,
                        );
                        Navigator.of(context).pop();
                      }
                    },
                  );
                } catch (error) {
                  // Xử lý các exception khác (nếu có)
                  if (mounted) {
                    DisplayMessage.errorMessage('Có lỗi xảy ra: ${error.toString()}', context);
                  }
                } finally {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
      style: ElevatedButton.styleFrom(
        backgroundColor: _isLoading ? Colors.grey : AppColors.primary,
        minimumSize: const Size(double.infinity, 60),
      ),
      child:
          _isLoading
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
              : const Text(
                'Cập nhật',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
    );
  }

  // Helper method to convert English gender to Vietnamese
  String? _convertGenderToVietnamese(String? gender) {
    if (gender == null || gender.isEmpty) return null;

    final genderLower = gender.toLowerCase();
    if (genderLower == 'male' || genderLower == 'nam') {
      return 'Nam';
    } else if (genderLower == 'female' || genderLower == 'nữ') {
      return 'Nữ';
    }
    return null; // Return null if not recognized
  }

  // Helper method to convert Vietnamese gender to English for API
  String? _convertGenderToEnglish(String? gender) {
    if (gender == null || gender.isEmpty) return null;

    if (gender == 'Nam') {
      return 'Male';
    } else if (gender == 'Nữ') {
      return 'Female';
    }
    return gender; // Return as is if not recognized
  }
}
