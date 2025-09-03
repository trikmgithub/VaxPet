import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaxpet/common/extensions/string_extension.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/data/pet/models/create_pet_req_params.dart';
import '../../../common/helper/message/display_message.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/pet/usecases/create_pet.dart';
import '../../../service_locator.dart';
import '../../main_bottom_navigator/pages/main_bottom_navigator.dart';

class CreatePetPage extends StatefulWidget {
  const CreatePetPage({super.key});

  @override
  State<CreatePetPage> createState() => _CreatePetPageState();
}

class _CreatePetPageState extends State<CreatePetPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _placeToLiveController = TextEditingController();
  final TextEditingController _placeOfBirthController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  bool _isSterilizedValue = false;
  int? _customerId; // Sử dụng biến đơn giản

  String? _selectedGender;
  String? _selectedSpecies;
  final ImagePicker _picker = ImagePicker();
  File? image;

  // Thêm biến quản lý trạng thái loading
  bool _isLoading = false;

  // Thêm biến để lưu ngày tháng theo định dạng mm/dd/yyyy cho API
  String? _dateOfBirthForApi;

  @override
  void initState() {
    super.initState();
    _loadCustomerId(); // Gọi phương thức lấy customerId khi widget khởi tạo
  }

  // Phương thức đơn giản để lấy và cập nhật customerId
  Future<void> _loadCustomerId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('customerId');

      setState(() {
        _customerId = customerId;
      });

      if (customerId == null) {
        debugPrint(
          'Warning: customerId không tìm thấy trong SharedPreferences',
        );
      } else {
        debugPrint('Loaded customerId: $customerId');
      }
    } catch (e) {
      debugPrint('Error loading customerId: $e');
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
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
    _breedController.dispose();
    _dateOfBirthController.dispose();
    _placeToLiveController.dispose();
    _placeOfBirthController.dispose();
    _weightController.dispose();
    _colorController.dispose();
    _nationalityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình để điều chỉnh giao diện responsive
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      appBar: BasicAppbar(
        title: const Text(
          'Tạo hồ sơ thú cưng',
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
                            'Thêm ảnh thú cưng',
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
                      // Section: Thông tin cơ bản
                      _buildSectionTitle('Thông tin cơ bản', Icons.pets),
                      _buildCard([
                        _buildNameField(),
                        const SizedBox(height: 16),
                        _buildRowFields(
                          first: _buildSpeciesField(),
                          second: _buildGenderField(),
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 16),
                        _buildBreedField(),
                      ]),

                      const SizedBox(height: 24),

                      // Section: Chi tiết thêm
                      _buildSectionTitle(
                        'Chi tiết thú cưng',
                        Icons.description,
                      ),
                      _buildCard([
                        _buildDateOfBirthField(),
                        const SizedBox(height: 16),
                        _buildRowFields(
                          first: _buildWeightField(),
                          second: _buildColorField(),
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 8),
                        _buildSterilizedField(),
                      ]),

                      const SizedBox(height: 24),

                      // Section: Thông tin nơi ở
                      _buildSectionTitle('Thông tin nơi ở', Icons.home),
                      _buildCard([
                        _buildPlaceToLiveField(),
                        const SizedBox(height: 16),
                        _buildRowFields(
                          first: _buildPlaceOfBirthField(),
                          second: _buildNationalityField(),
                          isTablet: isTablet,
                        ),
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

  // Widget để tạo layout 2 trường trên 1 hàng (responsive)
  Widget _buildRowFields({
    required Widget first,
    required Widget second,
    required bool isTablet,
  }) {
    if (isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: first),
          const SizedBox(width: 16),
          Expanded(child: second),
        ],
      );
    } else {
      return Column(children: [first, const SizedBox(height: 16), second]);
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Tên thú cưng *',
        hintText: 'Nhập tên thú cưng của bạn',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: Icon(Icons.pets_outlined, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      textCapitalization:
          TextCapitalization.words, // Tự động viết hoa chữ cái đầu mỗi từ
    );
  }

  Widget _buildSpeciesField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Loài thú cưng *',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      menuMaxHeight: 300,
      alignment: AlignmentDirectional.center,
      elevation: 2,
      isExpanded: true,
      value: _selectedSpecies,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng chọn loài thú cưng của bạn';
        }
        return null;
      },
      items: [
        DropdownMenuItem<String>(
          value: 'Chó',
          child: _buildDropdownItem(Icons.pets, const Color(0xFF6FB3D6), 'Chó'),
        ),
        DropdownMenuItem<String>(
          value: 'Mèo',
          child: _buildDropdownItem(Icons.pets, const Color(0xFF90C290), 'Mèo'),
        ),
      ],
      onChanged: (String? value) {
        setState(() {
          _selectedSpecies = value;
        });
      },
    );
  }

  Widget _buildDropdownItem(IconData icon, Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Make the row take minimum width
      children: [
        Icon(icon, color: color, size: 16), // Reduced icon size from 20 to 16
        const SizedBox(width: 6), // Reduced spacing from 10 to 6
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildBreedField() {
    return TextFormField(
      controller: _breedController,
      decoration: InputDecoration(
        labelText: 'Giống thú cưng *',
        hintText: 'Nhập giống thú cưng của bạn',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: Icon(Icons.category_outlined, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      textCapitalization: TextCapitalization.sentences,
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
          value: 'Đực',
          child: _buildDropdownItem(Icons.male, Colors.blue, 'Đực'),
        ),
        DropdownMenuItem<String>(
          value: 'Cái',
          child: _buildDropdownItem(Icons.female, Colors.pink, 'Cái'),
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
          firstDate: DateTime(2000),
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

          // Lưu ngày sinh theo định dạng mm/dd/yyyy cho API
          setState(() {
            _dateOfBirthForApi =
                "${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.year}";
          });
        }
      },
      readOnly: true,
    );
  }

  Widget _buildPlaceToLiveField() {
    return TextFormField(
      controller: _placeToLiveController,
      decoration: InputDecoration(
        labelText: 'Nơi ở *',
        hintText: 'Nhập nơi ở thú cưng của bạn',
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

  Widget _buildPlaceOfBirthField() {
    return TextFormField(
      controller: _placeOfBirthController,
      decoration: InputDecoration(
        labelText: 'Nơi sinh *',
        hintText: 'Nhập nơi sinh thú cưng của bạn',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: Icon(Icons.place_outlined, color: AppColors.primary),
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
          'Hình ảnh thú cưng',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 10), // Thêm khoảng cách giữa text và vòng tròn
        Center(
          // Bọc InkWell trong Center để đảm bảo căn giữa
          child: InkWell(
            onTap: _pickImage,
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                shape: BoxShape.circle,
              ),
              clipBehavior:
                  Clip.antiAlias, // Đảm bảo ảnh được cắt theo hình tròn
              child:
                  image != null
                      ? Image.file(image!, fit: BoxFit.cover)
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
                            textAlign:
                                TextAlign.center, // Đảm bảo text được căn giữa
                          ),
                        ),
                      ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightField() {
    return TextFormField(
      controller: _weightController,
      decoration: InputDecoration(
        labelText: 'Cân nặng (Kg) *',
        hintText: 'Nhập cân nặng thú cưng của bạn',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: Icon(
          Icons.monitor_weight_outlined,
          color: AppColors.primary,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _buildColorField() {
    return TextFormField(
      controller: _colorController,
      decoration: InputDecoration(
        labelText: 'Màu sắc *',
        hintText: 'Nhập màu sắc thú cưng của bạn',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: Icon(Icons.color_lens_outlined, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      textCapitalization:
          TextCapitalization.words, // Tự động viết hoa chữ cái đầu mỗi từ
    );
  }

  Widget _buildNationalityField() {
    return TextFormField(
      controller: _nationalityController,
      decoration: InputDecoration(
        labelText: 'Quốc tịch *',
        hintText: 'Nhập quốc tịch thú cưng của bạn',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: Icon(Icons.public_outlined, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      textCapitalization:
          TextCapitalization.words, // Tự động viết hoa chữ cái đầu mỗi từ
    );
  }

  Widget _buildSterilizedField() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: Row(
        children: [
          Icon(Icons.medical_services_outlined, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Đã thiến/triệt sản',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Switch(
            value: _isSterilizedValue,
            onChanged: (bool value) {
              setState(() {
                _isSterilizedValue = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
        ),
        onPressed:
            _isLoading
                ? null
                : () async {
                  // Thiết lập trạng thái loading
                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    // Kiểm tra dữ liệu trước khi gửi request
                    if (_customerId == null) {
                      DisplayMessage.errorMessage(
                        'Không thể xác định thông tin người dùng',
                        context,
                      );
                      return;
                    }

                    // Kiểm tra các trường bắt buộc
                    if (_nameController.text.isEmpty ||
                        _selectedSpecies == null ||
                        _breedController.text.isEmpty ||
                        _selectedGender == null ||
                        _dateOfBirthController.text.isEmpty ||
                        _placeToLiveController.text.isEmpty ||
                        _placeOfBirthController.text.isEmpty ||
                        _weightController.text.isEmpty ||
                        _colorController.text.isEmpty ||
                        _nationalityController.text.isEmpty) {
                      DisplayMessage.errorMessage(
                        'Vui lòng điền đầy đủ thông tin bắt buộc',
                        context,
                      );
                      return;
                    }

                    // Tạo tham số cho API call
                    final params = CreatePetReqParams(
                      customerId: _customerId!,
                      name: _nameController.text.trim().capitalizeFirstLetter(),
                      species: _selectedSpecies! == "Chó" ? "Dog" : "Cat",
                      breed:
                          _breedController.text.trim().capitalizeFirstLetter(),
                      gender: _selectedGender!,
                      dateOfBirth: _dateOfBirthForApi ?? '',
                      placeToLive:
                          _placeToLiveController.text
                              .trim()
                              .capitalizeFirstLetter(),
                      placeOfBirth:
                          _placeOfBirthController.text
                              .trim()
                              .capitalizeFirstLetter(),
                      image: image?.path,
                      weight: _weightController.text.trim(),
                      color:
                          _colorController.text.trim().capitalizeFirstLetter(),
                      nationality:
                          _nationalityController.text
                              .trim()
                              .capitalizeFirstLetter(),
                      isSterilized: _isSterilizedValue,
                    );

                    debugPrint('Sending request with params: $params');

                    // Gọi API
                    final result = await sl<CreatePetUseCase>().call(
                      params: params,
                    );

                    // Kiểm tra xem widget còn mounted không trước khi sử dụng context
                    if (!mounted) return;

                    // Xử lý kết quả
                    result.fold(
                      (failure) {
                        // Hiển thị lỗi từ backend
                        String errorMessage = failure.toString();
                        if (errorMessage.startsWith('Lỗi: ')) {
                          errorMessage = errorMessage.substring(5); // Bỏ prefix "Lỗi: "
                        }
                        DisplayMessage.errorMessage(
                          errorMessage,
                          context,
                        );
                      },
                      (success) {
                        DisplayMessage.successMessage(
                          'Đã tạo thú cưng thành công',
                          context,
                        );
                        AppNavigator.pushAndRemove(
                          context,
                          MainBottomNavigatorPage(),
                        );
                      },
                    );
                  } catch (e) {
                    // Kiểm tra mounted trước khi sử dụng context
                    if (mounted) {
                      DisplayMessage.errorMessage(
                        'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.',
                        context,
                      );
                    }
                  } finally {
                    // Vô hiệu hóa trạng thái loading
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
        child:
            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                  'Hoàn thành',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
      ),
    );
  }
}
