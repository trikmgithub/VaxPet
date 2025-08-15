import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/presentation/pet_record/bloc/get_pet_record_cubit.dart';
import 'package:vaxpet/presentation/pet_record/bloc/get_pet_record_state.dart';
import '../../../domain/pet_record/entities/pet_record.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../core/configs/theme/app_colors.dart';

class PetRecordPage extends StatelessWidget {
  final int petId;
  final String? petName;
  final String? petImage;
  final String? petSpecies;
  final String? petBirthday;

  const PetRecordPage({
    super.key,
    required this.petId,
    this.petName,
    this.petImage,
    this.petSpecies,
    this.petBirthday,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetPetRecordCubit()..getPetRecord(petId),
      child: _PetRecordView(
        petId: petId,
        petName: petName,
        petImage: petImage,
        petSpecies: petSpecies,
        petBirthday: petBirthday,
      ),
    );
  }
}

class _PetRecordView extends StatefulWidget {
  final int petId;
  final String? petName;
  final String? petImage;
  final String? petSpecies;
  final String? petBirthday;

  const _PetRecordView({
    required this.petId,
    this.petName,
    this.petImage,
    this.petSpecies,
    this.petBirthday,
  });

  @override
  State<_PetRecordView> createState() => _PetRecordViewState();
}

class _PetRecordViewState extends State<_PetRecordView> {
  // Phương thức convert species sang tiếng Việt
  String _convertSpeciesToVietnamese(String? species) {
    if (species == null || species.isEmpty || species == 'N/A') {
      return 'N/A';
    }
    return species.toLowerCase() == 'dog' ? 'Chó' : 'Mèo';
  }

  // Phương thức format ngày sinh về dd/mm/yyyy
  String _formatBirthday(String? birthday) {
    if (birthday == null || birthday.isEmpty || birthday == 'N/A') {
      return 'N/A';
    }

    try {
      DateTime? birthDate;

      // Format: yyyy-MM-dd hoặc yyyy-MM-ddTHH:mm:ss
      if (birthday.contains('-') && birthday.length >= 10) {
        birthDate = DateTime.tryParse(birthday.substring(0, 10));
      }
      // Format: dd/MM/yyyy (already correct format)
      else if (birthday.contains('/')) {
        final parts = birthday.split('/');
        if (parts.length == 3 && parts[0].length <= 2) {
          return birthday; // Already in dd/MM/yyyy format
        }
      }

      if (birthDate != null) {
        return '${birthDate.day.toString().padLeft(2, '0')}/${birthDate.month.toString().padLeft(2, '0')}/${birthDate.year}';
      }

      return birthday;
    } catch (e) {
      return 'N/A';
    }
  }

  // Phương thức tính tuổi từ ngày sinh
  String _calculateAge(String? birthday) {
    if (birthday == null || birthday.isEmpty || birthday == 'N/A') {
      return '';
    }

    try {
      DateTime? birthDate;

      // Format: yyyy-MM-dd
      if (birthday.contains('-') && birthday.length >= 10) {
        birthDate = DateTime.tryParse(birthday.substring(0, 10));
      }
      // Format: dd/MM/yyyy
      else if (birthday.contains('/')) {
        final parts = birthday.split('/');
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
        return '';
      }

      final now = DateTime.now();
      final difference = now.difference(birthDate);
      final totalDays = difference.inDays;

      if (totalDays < 7) {
        return ' • $totalDays ngày tuổi';
      } else if (totalDays < 365) {
        final weeks = (totalDays / 7).floor();
        return ' • 0 tuổi ($weeks tuần)';
      } else {
        final years = (totalDays / 365).floor();
        final remainingDays = totalDays % 365;
        final remainingWeeks = (remainingDays / 7).floor();

        if (remainingWeeks > 0) {
          return ' • $years năm $remainingWeeks tuần tuổi';
        } else {
          return ' • $years năm tuổi';
        }
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: BasicAppbar(
        title: const Text(
          'Hồ sơ tiêm chủng',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: BlocBuilder<GetPetRecordCubit, GetPetRecordState>(
        builder: (context, state) {
          if (state is GetPetRecordLoading) {
            return _buildLoadingState();
          } else if (state is GetPetRecordError) {
            return _buildErrorState(context, state);
          } else if (state is GetPetRecordLoaded) {
            if (state.petRecords.isEmpty) {
              return _buildEmptyStateWithHeader(context);
            }
            return _buildLoadedStateWithHeader(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPetHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Pet image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child:
                    widget.petImage != null && widget.petImage!.isNotEmpty
                        ? Image.network(
                          widget.petImage!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultPetAvatar();
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                        )
                        : _buildDefaultPetAvatar(),
              ),
            ),
            const SizedBox(width: 16),

            // Pet information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pet name
                  Text(
                    widget.petName ?? 'Thú cưng',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Pet species and age with icons
                  Row(
                    children: [
                      Icon(
                        _getSpeciesIcon(widget.petSpecies),
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${widget.petSpecies}${_calculateAge(widget.petBirthday)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Birthday if available
                  if (widget.petBirthday != null &&
                      _formatBirthday(widget.petBirthday) != 'N/A') ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.cake, size: 18, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'Sinh nhật: ${_formatBirthday(widget.petBirthday)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultPetAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getSpeciesIcon(widget.petSpecies),
        size: 40,
        color: AppColors.primary,
      ),
    );
  }

  IconData _getSpeciesIcon(String? species) {
    if (species == null || species.isEmpty) {
      return Icons.pets;
    }
    return species.toLowerCase() == 'dog' ? Icons.pets : Icons.pets;
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
          const SizedBox(height: 16),
          Text(
            'Đang tải hồ sơ tiêm chủng...',
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

  Widget _buildErrorState(BuildContext context, GetPetRecordError state) {
    return RefreshIndicator(
      onRefresh:
          () =>
              context.read<GetPetRecordCubit>().refreshPetRecord(widget.petId),
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 40,
                    color: Colors.red[400],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Có lỗi xảy ra',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<GetPetRecordCubit>().getPetRecord(
                      widget.petId,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Thử lại',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyStateWithHeader(BuildContext context) {
    return RefreshIndicator(
      onRefresh:
          () =>
              context.read<GetPetRecordCubit>().refreshPetRecord(widget.petId),
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Pet header - cuộn cùng với nội dung
            _buildPetHeader(),

            // Empty state content
            SizedBox(
              height: MediaQuery.of(context).size.height - 300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.medical_services_outlined,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Chưa có hồ sơ tiêm chủng',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hồ sơ tiêm chủng sẽ được hiển thị sau khi\nthú cưng được tiêm vaccine lần đầu',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedStateWithHeader(
    BuildContext context,
    GetPetRecordLoaded state,
  ) {
    return RefreshIndicator(
      onRefresh:
          () =>
              context.read<GetPetRecordCubit>().refreshPetRecord(widget.petId),
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          // Pet header as sliver - sẽ cuộn cùng với content
          SliverToBoxAdapter(child: _buildPetHeader()),

          // Disease cards
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final disease = state.petRecords[index];
                return _buildDiseaseCard(disease);
              }, childCount: state.petRecords.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard(PetRecordEntity disease) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Disease header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.medical_services,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    disease.diseaseName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${disease.doses.length} mũi',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Doses list
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children:
                  disease.doses.asMap().entries.map((entry) {
                    int index = entry.key;
                    VaccineDoseEntity dose = entry.value;
                    bool isLast = index == disease.doses.length - 1;
                    return _buildDoseItem(dose, isLast);
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoseItem(VaccineDoseEntity dose, bool isLast) {
    final isCompleted = dose.isCompleted;
    final statusColor = isCompleted ? AppColors.primary : Colors.orange[600]!;
    final backgroundColor =
        isCompleted
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.orange[50]!;
    final statusIcon = isCompleted ? Icons.check_circle : Icons.schedule;
    final statusText = isCompleted ? 'Đã tiêm' : 'Chưa tiêm';

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dose number indicator
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${dose.dose}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 32,
                    color: Colors.grey[300],
                    margin: const EdgeInsets.only(top: 8),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Dose information
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status row
                    Row(
                      children: [
                        Text(
                          'Mũi ${dose.dose}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textBlack,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                statusText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Date information
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label:
                          isCompleted && dose.vaccinationDate != null
                              ? 'Ngày tiêm'
                              : 'Ngày dự kiến',
                      value: _formatDate(
                        isCompleted && dose.vaccinationDate != null
                            ? dose.vaccinationDate!
                            : dose.preferedDate,
                      ),
                      iconColor: statusColor,
                    ),

                    // Vaccine info if completed
                    if (isCompleted &&
                        dose.appointmentDetail?.vaccineBatch?.vaccine !=
                            null) ...[
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        icon: Icons.medical_information,
                        label: 'Vắc xin',
                        value:
                            dose.appointmentDetail!.vaccineBatch!.vaccine.name,
                        iconColor: statusColor,
                      ),
                    ],

                    // Reaction if any
                    if (isCompleted &&
                        dose.reaction != null &&
                        dose.reaction!.isNotEmpty &&
                        dose.reaction != 'ko') ...[
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        icon: Icons.warning,
                        label: 'Phản ứng',
                        value: dose.reaction!,
                        iconColor: Colors.orange[600]!,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
        if (!isLast) const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
