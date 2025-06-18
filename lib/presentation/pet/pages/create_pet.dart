import 'dart:io';
import 'package:dartz/dartz.dart' hide State; // Hide State from dartz to avoid conflicts
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/common/widgets/appbar/app_bar.dart';
import 'package:vaxpet/common/widgets/reactive_button/reactive_button.dart';
import 'package:vaxpet/data/pet/models/create_pet_req_params.dart';
import 'package:vaxpet/presentation/home/pages/home.dart';

import '../../../common/helper/message/display_message.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/pet/usecases/create_pet.dart';
import '../../../service_locator.dart';

class CreatePetPage extends StatefulWidget {
  const CreatePetPage({super.key});

  @override
  State<CreatePetPage> createState() => _CreatePetPageState();
}

class _CreatePetPageState extends State<CreatePetPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _placeToLiveController = TextEditingController();
  final TextEditingController _placeOfBirthController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  bool _isSterilizedValue = false;
  int? _customerId;  // Sử dụng biến đơn giản

  String? _selectedGender;
  final ImagePicker _picker = ImagePicker();
  File? image;

  // Thêm biến quản lý trạng thái loading
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCustomerId();  // Gọi phương thức lấy customerId khi widget khởi tạo
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
        debugPrint('Warning: customerId không tìm thấy trong SharedPreferences');
      } else {
        debugPrint('Loaded customerId: $customerId');
      }
    } catch (e) {
      debugPrint('Error loading customerId: $e');
    }
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
    _speciesController.dispose();
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
    return Scaffold(
      appBar: BasicAppbar(
        title: const Text('Tạo hồ sơ thú cưng'),
      ),
      body: SafeArea (
        minimum: const EdgeInsets.only(
          top: 0,
          right: 24,
          left: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _image(),
              const SizedBox(height: 10),
              _name(),
              const SizedBox(height: 20),
              _species(),
              const SizedBox(height: 20),
              _breed(),
              const SizedBox(height: 20),
              _gender(),
              const SizedBox(height: 20),
              _dateOfBirth(),
              const SizedBox(height: 20),
              _placeToLive(),
              const SizedBox(height: 20),
              _placeOfBirth(),
              const SizedBox(height: 20),
              _weight(),
              const SizedBox(height: 20),
              _color(),
              const SizedBox(height: 20),
              _nationality(),
              const SizedBox(height: 20),
              _isSterilized(),
              const SizedBox(height: 20),
              _buttonCreatePet(),
              const SizedBox(height: 20),
          
            ],
          ),
        ),
      )
    );
  }

  Widget _name() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Tên thú cưng *',
        hintText: 'Nhập tên thú cưng của bạn',
      ),
    );
  }

  Widget _species() {
    return TextFormField(
      controller: _speciesController,
      decoration: const InputDecoration(
        labelText: 'Loài thú cưng *',
        hintText: 'Nhập loài thú cưng của bạn',
      ),
    );
  }

  Widget _breed() {
    return TextFormField(
      controller: _breedController,
      decoration: const InputDecoration(
        labelText: 'Giống thú cưng *',
        hintText: 'Nhập giống thú cưng của bạn',
      ),
    );
  }

  Widget _gender() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Giới tính *',
        border: OutlineInputBorder(),
      ),
      value: _selectedGender,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng chọn giới tính';
        }
        return null;
      },
      items: ['Đực', 'Cái'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        // Cập nhật giá trị đã chọn và rebuild UI
        setState(() {
          _selectedGender = value;
        });
      },
    );
  }

  Widget _dateOfBirth() {
    return TextFormField(
      controller: _dateOfBirthController,
      decoration: const InputDecoration(
        labelText: 'Ngày sinh *',
        hintText: 'Nhập ngày sinh th�� cưng của bạn',
      ),
      keyboardType: TextInputType.datetime,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          // format date dd/mm/yyyy
          String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
          _dateOfBirthController.text = formattedDate;
        }
      },
    );
  }

  Widget _placeToLive() {
    return TextFormField(
      controller: _placeToLiveController,
      decoration: const InputDecoration(
        labelText: 'Nơi ở *',
        hintText: 'Nhập nơi ở thú cưng của bạn',
      ),
    );
  }

  Widget _placeOfBirth() {
    return TextFormField(
      controller: _placeOfBirthController,
      decoration: const InputDecoration(
        labelText: 'Nơi sinh *',
        hintText: 'Nhập n��i sinh thú cưng của bạn',
      ),
    );
  }

  Widget _image() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,  // Thay đổi từ start sang center
      children: [
        const Text(
          'Hình ảnh thú cưng',
          style: TextStyle(fontSize: 16),
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

  Widget _weight() {
    return TextFormField(
      controller: _weightController,
      decoration: const InputDecoration(
        labelText: 'Cân nặng *',
        hintText: 'Nhập cân nặng thú cưng của bạn',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _color() {
    return TextFormField(
      controller: _colorController,
      decoration: const InputDecoration(
        labelText: 'Màu sắc *',
        hintText: 'Nhập màu sắc thú cưng của bạn',
      ),
    );
  }

  Widget _nationality() {
    return TextFormField(
      controller: _nationalityController,
      decoration: const InputDecoration(
        labelText: 'Quốc tịch *',
        hintText: 'Nhập quốc tịch thú cưng của bạn',
      ),
    );
  }

  Widget _isSterilized() {
    return Row(
      children: [
        Expanded(
          child: SwitchListTile(
            title: const Text(
              'Đã thiến/triệt sản',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            value: _isSterilizedValue,
            onChanged: (bool value) {
              setState(() {
                _isSterilizedValue = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buttonCreatePet() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
        ),
        onPressed: _isLoading ? null : () async {
          // Thiết lập trạng thái loading
          setState(() {
            _isLoading = true;
          });

          try {
            // Kiểm tra dữ li���u trước khi gửi request
            if (_customerId == null) {
              DisplayMessage.errorMessage('Không thể xác định thông tin người dùng', context);
              return;
            }

            // Kiểm tra các trường bắt buộc
            if (_nameController.text.isEmpty ||
                _speciesController.text.isEmpty ||
                _breedController.text.isEmpty ||
                _selectedGender == null ||
                _dateOfBirthController.text.isEmpty ||
                _placeToLiveController.text.isEmpty ||
                _placeOfBirthController.text.isEmpty ||
                _weightController.text.isEmpty ||
                _colorController.text.isEmpty ||
                _nationalityController.text.isEmpty) {
              DisplayMessage.errorMessage('Vui lòng điền đầy đủ thông tin bắt buộc', context);
              return;
            }

            // Tạo tham số cho API call
            final params = CreatePetReqParams(
              customerId: _customerId!,
              name: _nameController.text.trim(),
              species: _speciesController.text.trim(),
              breed: _breedController.text.trim(),
              gender: _selectedGender!,
              dateOfBirth: _dateOfBirthController.text.trim(),
              placeToLive: _placeToLiveController.text.trim(),
              placeOfBirth: _placeOfBirthController.text.trim(),
              image: image?.path,
              weight: _weightController.text.trim(),
              color: _colorController.text.trim(),
              nationality: _nationalityController.text.trim(),
              isSterilized: _isSterilizedValue,
            );

            debugPrint('Sending request with params: $params');

            // Gọi API
            final result = await sl<CreatePetUseCase>().call(params: params);

            // Xử lý kết quả
            result.fold(
              (failure) {
                debugPrint('Error creating pet: $failure');
                DisplayMessage.errorMessage('Không thể tạo thú cưng: $failure', context);
              },
              (success) {
                debugPrint('Pet created successfully');
                DisplayMessage.successMessage('Đã tạo thú cưng thành công', context);
                AppNavigator.pushAndRemove(context, HomePage());
              }
            );
          } catch (e) {
            debugPrint('Exception during API call: $e');
            DisplayMessage.errorMessage('Lỗi khi gửi yêu cầu: $e', context);
          } finally {
            // Vô hiệu hóa trạng thái loading
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          }
        },
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Tạo hồ sơ thú cưng', style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
