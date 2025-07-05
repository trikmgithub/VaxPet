import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/presentation/pet_information/bloc/pet_information_cubit.dart';
import 'package:vaxpet/presentation/pet_information/bloc/pet_information_state.dart';
import '../../../common/helper/message/display_message.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../core/configs/theme/app_colors.dart';

class PetInformationPage extends StatelessWidget {
  final int petId;

  const PetInformationPage({super.key, required this.petId});

  // Phương thức convert species sang tiếng Việt
  String _convertSpeciesToVietnamese(String? species) {
    if (species == null || species.isEmpty || species == 'N/A') {
      return 'N/A';
    }

    return species.toLowerCase() == 'dog' ? 'Chó' : 'Mèo';
  }

  // Phương thức format ngày sinh về dd/mm/yyyy
  String _formatDateOfBirth(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty || dateOfBirth == 'N/A') {
      return 'N/A';
    }

    try {
      DateTime? birthDate;

      // Format: yyyy-MM-dd
      if (dateOfBirth.contains('-') && dateOfBirth.length >= 10) {
        birthDate = DateTime.tryParse(dateOfBirth.substring(0, 10));
      }
      // Format: dd/MM/yyyy (already correct format)
      else if (dateOfBirth.contains('/')) {
        final parts = dateOfBirth.split('/');
        if (parts.length == 3 && parts[0].length <= 2) {
          return dateOfBirth; // Already in dd/MM/yyyy format
        }
      }

      if (birthDate != null) {
        return '${birthDate.day.toString().padLeft(2, '0')}/${birthDate.month.toString().padLeft(2, '0')}/${birthDate.year}';
      }

      return dateOfBirth;
    } catch (e) {
      return 'N/A';
    }
  }

  // Phương thức tính tuổi từ ngày sinh
  String _calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty || dateOfBirth == 'N/A') {
      return 'N/A';
    }

    try {
      // Thử parse nhiều format ngày khác nhau
      DateTime? birthDate;

      // Format: yyyy-MM-dd
      if (dateOfBirth.contains('-') && dateOfBirth.length >= 10) {
        birthDate = DateTime.tryParse(dateOfBirth.substring(0, 10));
      }
      // Format: dd/MM/yyyy
      else if (dateOfBirth.contains('/')) {
        final parts = dateOfBirth.split('/');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          if (day != null && month != null && year != null) {
            birthDate = DateTime(year, month, day);
          }
        }
      }
      // Format: dd-MM-yyyy
      else if (dateOfBirth.contains('-')) {
        final parts = dateOfBirth.split('-');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          if (day != null && month != null && year != null) {
            birthDate = DateTime(year, month, day);
          }
        }
      }

      if (birthDate == null) {
        return 'N/A';
      }

      final now = DateTime.now();
      final difference = now.difference(birthDate);
      final days = difference.inDays;

      if (days < 0) {
        return 'N/A'; // Ngày sinh trong tương lai
      } else if (days < 365) {
        final weeks = (days / 7).floor();
        return '0 tuổi ($weeks tuần)';
      } else {
        final years = (days / 365).floor();
        final remainingDays = days % 365;
        final weeks = (remainingDays / 7).floor();
        if (weeks > 0) {
          return '$years tuổi ($weeks tuần)';
        } else {
          return '$years tuổi';
        }
      }
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PetInformationCubit()..getPetInformation(petId),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: BasicAppbar(
          title: const Text(
            'Thông tin thú cưng',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: BlocBuilder<PetInformationCubit, PetInformationState>(
          builder: (context, state) {
            if (state is PetInformationLoading) {
              return _buildLoadingState();
            } else if (state is PetInformationLoaded) {
              return _buildLoadedState(context, state);
            } else if (state is PetInformationError) {
              return _buildErrorState(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _navigateToEditPet(BuildContext context) {
    DisplayMessage.errorMessage(
      'Chức năng chỉnh sửa thông tin thú cưng chưa được triển khai.',
      context,
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Đang tải thông tin...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, PetInformationError state) {
    return RefreshIndicator(
      onRefresh: () => context.read<PetInformationCubit>().refreshPetInformation(petId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Oops! Có lỗi xảy ra',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => context.read<PetInformationCubit>().getPetInformation(petId),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, PetInformationLoaded state) {
    final pet = state.pet;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return RefreshIndicator(
      onRefresh: () => context.read<PetInformationCubit>().refreshPetInformation(petId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Hero Section with Pet Image
            _buildHeroSection(context, pet, isTablet),

            // Information Cards
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 40 : 20,
                vertical: 16,
              ),
              child: Column(
                children: [
                  // Basic Information Card
                  _buildBasicInfoCard(context, pet, isTablet),
                  const SizedBox(height: 16),

                  // Physical Information Card
                  _buildPhysicalInfoCard(context, pet, isTablet),
                  const SizedBox(height: 16),

                  // Location Information Card
                  _buildLocationInfoCard(context, pet, isTablet),
                  const SizedBox(height: 16),

                  // Medical Information Card
                  _buildMedicalInfoCard(context, pet, isTablet),
                  const SizedBox(height: 32),

                  // Edit Button at bottom
                  _buildEditButton(context, isTablet),
                  const SizedBox(height: 52),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 20),
      child: ElevatedButton.icon(
        onPressed: () => _navigateToEditPet(context),
        icon: const Icon(Icons.edit, size: 20),
        label: const Text(
          'Chỉnh sửa thông tin',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: isTablet ? 16 : 14,
            horizontal: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: AppColors.primary.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, pet, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isTablet ? 40 : 32,
        horizontal: isTablet ? 40 : 20,
      ),
      margin: EdgeInsets.fromLTRB(
        isTablet ? 40 : 20,
        20,
        isTablet ? 40 : 20,
        0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.8),
            AppColors.primary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Pet Image
          Container(
            width: isTablet ? 160 : 120,
            height: isTablet ? 160 : 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: pet.image != null && pet.image!.isNotEmpty
                  ? Image.network(
                      pet.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(isTablet),
                    )
                  : _buildDefaultAvatar(isTablet),
            ),
          ),

          SizedBox(height: isTablet ? 20 : 16),

          // Pet Name
          Text(
            pet.name ?? 'Chưa có tên',
            style: TextStyle(
              fontSize: isTablet ? 28 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: isTablet ? 8 : 6),

          // Pet Code
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_convertSpeciesToVietnamese(pet.species) ?? 'N/A'}',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(bool isTablet) {
    return Container(
      color: Colors.white,
      child: Icon(
        Icons.pets,
        size: isTablet ? 80 : 60,
        color: AppColors.primary.withOpacity(0.5),
      ),
    );
  }

  Widget _buildBasicInfoCard(BuildContext context, pet, bool isTablet) {
    return _buildInfoCard(
      context: context,
      title: 'Thông tin cơ bản',
      icon: Icons.info_outline,
      isTablet: isTablet,
      children: [
        _buildInfoRow('Tên:', pet.name ?? 'N/A', Icons.pets),
        _buildInfoRow('Loài:', _convertSpeciesToVietnamese(pet.species) ?? 'N/A', Icons.category),
        _buildInfoRow('Giống:', pet.breed ?? 'N/A', Icons.label),
        _buildInfoRow('Giới tính:', pet.gender ?? 'N/A',
            pet.gender?.toLowerCase() == 'male' || pet.gender?.toLowerCase() == 'đực'
                ? Icons.male : Icons.female),
        _buildInfoRow('Ngày sinh:', _formatDateOfBirth(pet.dateOfBirth), Icons.cake),
      ],
    );
  }

  Widget _buildPhysicalInfoCard(BuildContext context, pet, bool isTablet) {
    return _buildInfoCard(
      context: context,
      title: 'Đặc điểm vật lý',
      icon: Icons.fitness_center,
      isTablet: isTablet,
      children: [
        _buildInfoRow('Cân nặng (kg):', pet.weight ?? 'N/A', Icons.monitor_weight),
        _buildInfoRow('Màu sắc:', pet.color ?? 'N/A', Icons.palette),
        _buildInfoRow('Tuổi:', _calculateAge(pet.dateOfBirth), Icons.schedule),
      ],
    );
  }

  Widget _buildLocationInfoCard(BuildContext context, pet, bool isTablet) {
    return _buildInfoCard(
      context: context,
      title: 'Thông tin địa điểm',
      icon: Icons.location_on,
      isTablet: isTablet,
      children: [
        _buildInfoRow('Nơi sinh:', pet.placeOfBirth ?? 'N/A', Icons.place),
        _buildInfoRow('Nơi ở hiện tại:', pet.placeToLive ?? 'N/A', Icons.home),
        _buildInfoRow('Quốc tịch:', pet.nationality ?? 'N/A', Icons.flag),
      ],
    );
  }

  Widget _buildMedicalInfoCard(BuildContext context, pet, bool isTablet) {
    return _buildInfoCard(
      context: context,
      title: 'Thông tin y tế',
      icon: Icons.medical_services,
      isTablet: isTablet,
      children: [
        _buildInfoRow(
          'Tình trạng triệt sản:',
          pet.isSterilized == true ? 'Đã triệt sản' : 'Chưa triệt sản',
          pet.isSterilized == true ? Icons.check_circle : Icons.cancel,
          valueColor: pet.isSterilized == true ? Colors.green[600] : Colors.orange[600],
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isTablet,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 24 : 20),
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
                child: Icon(
                  icon,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey[500],
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
