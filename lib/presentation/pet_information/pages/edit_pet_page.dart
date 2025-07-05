import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/domain/pet/entities/pet.dart';
import 'package:vaxpet/presentation/pet_information/bloc/edit_pet_cubit.dart';
import 'package:vaxpet/presentation/pet_information/bloc/edit_pet_state.dart';
import '../../../common/helper/message/display_message.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../core/configs/theme/app_colors.dart';

class EditPetPage extends StatefulWidget {
  final PetEntity pet;

  const EditPetPage({super.key, required this.pet});

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _weightController;
  late TextEditingController _colorController;
  late TextEditingController _placeToLiveController;
  late TextEditingController _placeOfBirthController;
  late TextEditingController _nationalityController;
  late TextEditingController _dateOfBirthController;

  String? _selectedSpecies;
  String? _selectedGender;
  bool _isSterilized = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.pet.name ?? '');
    _breedController = TextEditingController(text: widget.pet.breed ?? '');
    _weightController = TextEditingController(text: widget.pet.weight ?? '');
    _colorController = TextEditingController(text: widget.pet.color ?? '');
    _placeToLiveController = TextEditingController(text: widget.pet.placeToLive ?? '');
    _placeOfBirthController = TextEditingController(text: widget.pet.placeOfBirth ?? '');
    _nationalityController = TextEditingController(text: widget.pet.nationality ?? '');
    // Format ngày sinh về dd/mm/yyyy ngay từ đầu
    _dateOfBirthController = TextEditingController(text: _formatDateToDDMMYYYY(widget.pet.dateOfBirth));

    _selectedSpecies = widget.pet.species;
    // Convert Vietnamese gender to English for dropdown
    _selectedGender = _convertGenderToEnglish(widget.pet.gender);
    _isSterilized = widget.pet.isSterilized ?? false;
  }

  // Helper method to convert Vietnamese gender to English
  String? _convertGenderToEnglish(String? gender) {
    if (gender == null || gender.isEmpty) return null;

    final genderLower = gender.toLowerCase();
    if (genderLower == 'đực' || genderLower == 'male') {
      return 'Male';
    } else if (genderLower == 'cái' || genderLower == 'female') {
      return 'Female';
    }
    return gender; // Return as is if not recognized
  }

  // Helper method to convert English gender back to original format if needed
  String? _convertGenderForSaving(String? gender) {
    // Keep it in English for consistency with the backend
    return gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _weightController.dispose();
    _colorController.dispose();
    _placeToLiveController.dispose();
    _placeOfBirthController.dispose();
    _nationalityController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _parseDate(_dateOfBirthController.text) ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateOfBirthController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  DateTime? _parseDate(String dateString) {
    if (dateString.isEmpty) return null;

    try {
      if (dateString.contains('/')) {
        final parts = dateString.split('/');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]), // year
            int.parse(parts[1]), // month
            int.parse(parts[0]), // day
          );
        }
      } else if (dateString.contains('-')) {
        return DateTime.tryParse(dateString);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  // Helper method to format any date to dd/MM/yyyy
  String _formatDateToDDMMYYYY(String? dateString) {
    if (dateString == null || dateString.isEmpty || dateString == 'N/A') {
      return '';
    }

    try {
      DateTime? birthDate;

      // Format: yyyy-MM-dd hoặc yyyy/MM/dd
      if (dateString.contains('-') || dateString.contains('/')) {
        // Thử parse theo format ISO hoặc các format khác
        if (dateString.contains('-')) {
          birthDate = DateTime.tryParse(dateString);
        } else if (dateString.contains('/')) {
          final parts = dateString.split('/');
          if (parts.length == 3) {
            // Kiểm tra xem là dd/MM/yyyy hay yyyy/MM/dd
            if (parts[0].length == 4) {
              // yyyy/MM/dd
              final year = int.tryParse(parts[0]);
              final month = int.tryParse(parts[1]);
              final day = int.tryParse(parts[2]);
              if (year != null && month != null && day != null) {
                birthDate = DateTime(year, month, day);
              }
            } else {
              // dd/MM/yyyy
              final day = int.tryParse(parts[0]);
              final month = int.tryParse(parts[1]);
              final year = int.tryParse(parts[2]);
              if (day != null && month != null && year != null) {
                birthDate = DateTime(year, month, day);
              }
            }
          }
        }
      }

      if (birthDate != null) {
        return '${birthDate.day.toString().padLeft(2, '0')}/${birthDate.month.toString().padLeft(2, '0')}/${birthDate.year}';
      }

      return dateString; // Return original if can't parse
    } catch (e) {
      return dateString ?? '';
    }
  }

  PetEntity _createUpdatedPet() {
    // Chỉ gửi những field nào thay đổi so với dữ liệu gốc
    return PetEntity(
      petId: widget.pet.petId,
      customerId: widget.pet.customerId,
      petCode: widget.pet.petCode,
      // Chỉ gửi name nếu thay đổi
      name: _nameController.text.trim() != (widget.pet.name ?? '')
          ? _nameController.text.trim()
          : widget.pet.name,
      // Chỉ gửi species nếu thay đổi
      species: _selectedSpecies != widget.pet.species
          ? _selectedSpecies
          : widget.pet.species,
      // Chỉ gửi breed nếu thay đổi
      breed: _breedController.text.trim() != (widget.pet.breed ?? '')
          ? _breedController.text.trim()
          : widget.pet.breed,
      age: widget.pet.age, // Keep original age
      // Chỉ gửi gender nếu thay đổi (so sánh với giá trị đã convert)
      gender: _selectedGender != _convertGenderToEnglish(widget.pet.gender)
          ? _selectedGender
          : widget.pet.gender,
      // Chỉ gửi dateOfBirth nếu thay đổi (so sánh với format chuẩn)
      dateOfBirth: _dateOfBirthController.text.trim() != _formatDateToDDMMYYYY(widget.pet.dateOfBirth)
          ? _dateOfBirthController.text.trim()
          : widget.pet.dateOfBirth,
      // Chỉ gửi placeToLive nếu thay đổi
      placeToLive: _placeToLiveController.text.trim() != (widget.pet.placeToLive ?? '')
          ? _placeToLiveController.text.trim()
          : widget.pet.placeToLive,
      // Chỉ gửi placeOfBirth nếu thay đổi
      placeOfBirth: _placeOfBirthController.text.trim() != (widget.pet.placeOfBirth ?? '')
          ? _placeOfBirthController.text.trim()
          : widget.pet.placeOfBirth,
      // Không gửi image URL hiện tại (Cloudinary), chỉ gửi khi có ảnh mới
      image: widget.pet.image, // Keep original image URL, sẽ được thay đổi khi user chọn ảnh mới
      // Chỉ gửi weight nếu thay đổi
      weight: _weightController.text.trim() != (widget.pet.weight ?? '')
          ? _weightController.text.trim()
          : widget.pet.weight,
      // Chỉ gửi color nếu thay đổi
      color: _colorController.text.trim() != (widget.pet.color ?? '')
          ? _colorController.text.trim()
          : widget.pet.color,
      // Chỉ gửi nationality nếu thay đổi
      nationality: _nationalityController.text.trim() != (widget.pet.nationality ?? '')
          ? _nationalityController.text.trim()
          : widget.pet.nationality,
      // Chỉ gửi isSterilized nếu thay đổi
      isSterilized: _isSterilized != (widget.pet.isSterilized ?? false)
          ? _isSterilized
          : widget.pet.isSterilized,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditPetCubit(),
      child: _EditPetForm(
        pet: widget.pet,
        formKey: _formKey,
        nameController: _nameController,
        breedController: _breedController,
        weightController: _weightController,
        colorController: _colorController,
        placeToLiveController: _placeToLiveController,
        placeOfBirthController: _placeOfBirthController,
        nationalityController: _nationalityController,
        dateOfBirthController: _dateOfBirthController,
        selectedSpecies: _selectedSpecies,
        selectedGender: _selectedGender,
        isSterilized: _isSterilized,
        onSpeciesChanged: (value) => setState(() => _selectedSpecies = value),
        onGenderChanged: (value) => setState(() => _selectedGender = value),
        onSterilizedChanged: (value) => setState(() => _isSterilized = value),
        onDateSelect: _selectDate,
        onSubmit: _createUpdatedPet,
      ),
    );
  }
}

class _EditPetForm extends StatelessWidget {
  final PetEntity pet;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController breedController;
  final TextEditingController weightController;
  final TextEditingController colorController;
  final TextEditingController placeToLiveController;
  final TextEditingController placeOfBirthController;
  final TextEditingController nationalityController;
  final TextEditingController dateOfBirthController;
  final String? selectedSpecies;
  final String? selectedGender;
  final bool isSterilized;
  final Function(String?) onSpeciesChanged;
  final Function(String?) onGenderChanged;
  final Function(bool) onSterilizedChanged;
  final VoidCallback onDateSelect;
  final PetEntity Function() onSubmit;

  const _EditPetForm({
    required this.pet,
    required this.formKey,
    required this.nameController,
    required this.breedController,
    required this.weightController,
    required this.colorController,
    required this.placeToLiveController,
    required this.placeOfBirthController,
    required this.nationalityController,
    required this.dateOfBirthController,
    required this.selectedSpecies,
    required this.selectedGender,
    required this.isSterilized,
    required this.onSpeciesChanged,
    required this.onGenderChanged,
    required this.onSterilizedChanged,
    required this.onDateSelect,
    required this.onSubmit,
  });

  void _submitForm(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final updatedPet = onSubmit();
      context.read<EditPetCubit>().updatePet(updatedPet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: BasicAppbar(
        title: const Text(
          'Chỉnh sửa thông tin thú cưng',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: BlocListener<EditPetCubit, EditPetState>(
        listener: (context, state) {
          if (state is EditPetSuccess) {
            DisplayMessage.successMessage('Cập nhật thông tin thành công!', context);
            Navigator.pop(context, true); // Return true to indicate success
          } else if (state is EditPetError) {
            DisplayMessage.errorMessage(state.message, context);
          }
        },
        child: BlocBuilder<EditPetCubit, EditPetState>(
          builder: (context, state) {
            return Stack(
              children: [
                _buildForm(context),
                if (state is EditPetLoading) _buildLoadingOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              const Text(
                'Đang cập nhật...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _buildBasicInfoCard(context),
            const SizedBox(height: 16),
            _buildPhysicalInfoCard(),
            const SizedBox(height: 16),
            _buildLocationInfoCard(),
            const SizedBox(height: 16),
            _buildMedicalInfoCard(),
            const SizedBox(height: 32),
            _buildSubmitButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard(BuildContext context) {
    return _buildCard(
      title: 'Thông tin cơ bản',
      icon: Icons.info_outline,
      children: [
        _buildTextFormField(
          controller: nameController,
          label: 'Tên thú cưng',
          icon: Icons.pets,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Vui lòng nhập tên thú cưng';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Loài',
          value: selectedSpecies,
          icon: Icons.category,
          items: const ['Dog', 'Cat'],
          onChanged: onSpeciesChanged,
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: breedController,
          label: 'Giống',
          icon: Icons.label,
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Giới tính',
          value: selectedGender,
          icon: Icons.person,
          items: const ['Male', 'Female'],
          onChanged: onGenderChanged,
        ),
        const SizedBox(height: 16),
        _buildDateField(context),
      ],
    );
  }

  Widget _buildPhysicalInfoCard() {
    return _buildCard(
      title: 'Đặc điểm vật lý',
      icon: Icons.fitness_center,
      children: [
        _buildTextFormField(
          controller: weightController,
          label: 'Cân nặng (kg)',
          icon: Icons.monitor_weight,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: colorController,
          label: 'Màu sắc',
          icon: Icons.palette,
        ),
      ],
    );
  }

  Widget _buildLocationInfoCard() {
    return _buildCard(
      title: 'Thông tin địa điểm',
      icon: Icons.location_on,
      children: [
        _buildTextFormField(
          controller: placeOfBirthController,
          label: 'Nơi sinh',
          icon: Icons.place,
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: placeToLiveController,
          label: 'Nơi ở hiện tại',
          icon: Icons.home,
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: nationalityController,
          label: 'Quốc tịch',
          icon: Icons.flag,
        ),
      ],
    );
  }

  Widget _buildMedicalInfoCard() {
    return _buildCard(
      title: 'Thông tin y tế',
      icon: Icons.medical_services,
      children: [
        Row(
          children: [
            Icon(Icons.medical_services, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            const Text(
              'Tình trạng triệt sản:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Switch(
              value: isSterilized,
              onChanged: onSterilizedChanged,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
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
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item == 'Dog' ? 'Chó' : item == 'Cat' ? 'Mèo' :
                      item == 'Male' ? 'Đực' : item == 'Female' ? 'Cái' : item),
        );
      }).toList(),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      controller: dateOfBirthController,
      readOnly: true,
      onTap: onDateSelect,
      decoration: InputDecoration(
        labelText: 'Ngày sinh',
        prefixIcon: Icon(Icons.cake, color: AppColors.primary),
        suffixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _submitForm(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Cập nhật thông tin',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
