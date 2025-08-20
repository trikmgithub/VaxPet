import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/sample_schedule_pet_cubit.dart';
import '../bloc/sample_schedule_pet_state.dart';

class SampleSchedulePetPage extends StatelessWidget {
  final String petName;
  final int petId;
  final String? petBirthday;
  final String petSpecies;

  const SampleSchedulePetPage({
    super.key,
    required this.petName,
    required this.petId,
    this.petBirthday,
    required this.petSpecies
  });

  // Phương thức dịch loài thú cưng từ tiếng Anh sang tiếng Việt
  String _translatePetSpecies(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
      case 'chó':
        return 'Chó';
      case 'cat':
      case 'mèo':
        return 'Mèo';
      default:
        return species; // Trả về nguyên bản nếu không tìm thấy bản dịch
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 400;
    final bool isVerySmallScreen = screenSize.width < 360;

    return BlocProvider(
      create: (context) => SampleSchedulePetCubit()..getSampleSchedulePet(petSpecies),
      child: Scaffold(
        backgroundColor: AppColors.returnBackground,
        appBar: BasicAppbar(
          title: Text(
            'Lịch gợi ý tiêm',
            style: TextStyle(
              color: Colors.white,
              fontSize: isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20),
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 0,
        ),
        body: BlocBuilder<SampleSchedulePetCubit, SampleSchedulePetState>(
          builder: (context, state) {
            if (state is SampleSchedulePetLoading) {
              return _buildLoadingState(isSmallScreen);
            } else if (state is SampleSchedulePetFailure) {
              return _buildErrorState(context, state.errorMessage, isSmallScreen);
            } else if (state is SampleSchedulePetLoaded) {
              return _buildLoadedState(context, state.speciesSchedules, isSmallScreen, isVerySmallScreen);
            }

            return _buildEmptyState(context, isSmallScreen);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isSmallScreen) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            Text(
              'Đang tải lịch tiêm...',
              style: TextStyle(
                color: AppColors.textGray,
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage, bool isSmallScreen) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red.shade100, width: 2),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: isSmallScreen ? 40 : 48,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Có lỗi xảy ra',
              style: TextStyle(
                fontSize: isSmallScreen ? 18 : 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: AppColors.textGray,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.read<SampleSchedulePetCubit>().getSampleSchedulePet(petSpecies);
              },
              icon: Icon(Icons.refresh_rounded, size: isSmallScreen ? 18 : 20),
              label: Text(
                'Thử lại',
                style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 20 : 24,
                  vertical: isSmallScreen ? 10 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isSmallScreen) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.vaccines_outlined,
                size: isSmallScreen ? 40 : 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Không có dữ liệu',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hiện tại chưa có lịch tiêm nào cho loài này',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: AppColors.textGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, List<SpeciesSchedule> speciesSchedules, bool isSmallScreen, bool isVerySmallScreen) {
    if (speciesSchedules.isEmpty) {
      return _buildEmptyState(context, isSmallScreen);
    }

    return CustomScrollView(
      slivers: [
        // Pet info header
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.all(isVerySmallScreen ? 12 : 16),
            padding: EdgeInsets.all(isVerySmallScreen ? 16 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isVerySmallScreen ? 10 : 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    petSpecies.toLowerCase().contains('chó') || petSpecies.toLowerCase().contains('dog')
                        ? Icons.pets
                        : Icons.pets_outlined,
                    color: Colors.white,
                    size: isVerySmallScreen ? 24 : 28,
                  ),
                ),
                SizedBox(width: isVerySmallScreen ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        petName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lịch tiêm gợi ý cho ${petSpecies}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: isVerySmallScreen ? 12 : (isSmallScreen ? 14 : 16),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Vaccination schedules
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, speciesIndex) {
              final speciesSchedule = speciesSchedules[speciesIndex];

              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: isVerySmallScreen ? 12 : 16,
                  vertical: 8
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Species header
                    Container(
                      padding: EdgeInsets.all(isVerySmallScreen ? 16 : 20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: AppColors.primary,
                            size: isVerySmallScreen ? 20 : 24,
                          ),
                          SizedBox(width: isVerySmallScreen ? 8 : 12),
                          Expanded(
                            child: Text(
                              'Lịch tiêm ${_translatePetSpecies(speciesSchedule.species)}',
                              style: TextStyle(
                                fontSize: isVerySmallScreen ? 14 : (isSmallScreen ? 16 : 18),
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Disease schedules
                    Padding(
                      padding: EdgeInsets.all(isVerySmallScreen ? 16 : 20),
                      child: Column(
                        children: speciesSchedule.schedules.asMap().entries.map((entry) {
                          final diseaseSchedule = entry.value;
                          final isLastDisease = entry.key == speciesSchedule.schedules.length - 1;

                          return _buildDiseaseScheduleCard(
                            context,
                            diseaseSchedule,
                            isSmallScreen,
                            isVerySmallScreen,
                            isLastDisease,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
            childCount: speciesSchedules.length,
          ),
        ),

        // Bottom spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
      ],
    );
  }

  Widget _buildDiseaseScheduleCard(
    BuildContext context,
    DiseaseSchedule diseaseSchedule,
    bool isSmallScreen,
    bool isVerySmallScreen,
    bool isLastDisease,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: isLastDisease ? 0 : (isVerySmallScreen ? 16 : 24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Disease header
          Container(
            padding: EdgeInsets.symmetric(
              vertical: isVerySmallScreen ? 10 : 12,
              horizontal: isVerySmallScreen ? 12 : 16
            ),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isVerySmallScreen ? 6 : 8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.vaccines_rounded,
                    color: Colors.green.shade600,
                    size: isVerySmallScreen ? 16 : 20,
                  ),
                ),
                SizedBox(width: isVerySmallScreen ? 8 : 12),
                Expanded(
                  child: Text(
                    diseaseSchedule.diseaseName,
                    style: TextStyle(
                      fontSize: isVerySmallScreen ? 13 : (isSmallScreen ? 15 : 16),
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: isVerySmallScreen ? 4 : 8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isVerySmallScreen ? 6 : 8,
                    vertical: isVerySmallScreen ? 3 : 4
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${diseaseSchedule.schedules.length} mũi',
                    style: TextStyle(
                      fontSize: isVerySmallScreen ? 10 : 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: isVerySmallScreen ? 12 : 16),

          // Vaccination doses
          ...diseaseSchedule.schedules.asMap().entries.map((entry) {
            final schedule = entry.value;
            final doseIndex = entry.key;
            final isLastDose = doseIndex == diseaseSchedule.schedules.length - 1;

            return _buildVaccinationDoseCard(
              context,
              schedule,
              isSmallScreen,
              isVerySmallScreen,
              isLastDose,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildVaccinationDoseCard(
    BuildContext context,
    VaccinationSchedule schedule,
    bool isSmallScreen,
    bool isVerySmallScreen,
    bool isLastDose,
  ) {
    return Container(
      margin: EdgeInsets.only(
        bottom: isLastDose ? 0 : (isVerySmallScreen ? 8 : 12),
        left: isVerySmallScreen ? 12 : 16,
      ),
      padding: EdgeInsets.all(isVerySmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dose number badge
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: isVerySmallScreen ? 4 : 6,
                  horizontal: isVerySmallScreen ? 8 : 10
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade200,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Mũi ${schedule.doseNumber}',
                  style: TextStyle(
                    fontSize: isVerySmallScreen ? 10 : 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(width: isVerySmallScreen ? 12 : 16),

              // Schedule info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time and status row - make it wrap on small screens
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: isVerySmallScreen ? 14 : 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Tuần tuổi: ${schedule.ageInterval}',
                              style: TextStyle(
                                fontSize: isVerySmallScreen ? 12 : (isSmallScreen ? 14 : 15),
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (schedule.disease.description.isNotEmpty) ...[
            SizedBox(height: isVerySmallScreen ? 6 : 8),
            Container(
              padding: EdgeInsets.all(isVerySmallScreen ? 8 : 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100, width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: isVerySmallScreen ? 14 : 16,
                    color: Colors.blue.shade600,
                  ),
                  SizedBox(width: isVerySmallScreen ? 6 : 8),
                  Expanded(
                    child: Text(
                      schedule.disease.description,
                      style: TextStyle(
                        fontSize: isVerySmallScreen ? 10 : (isSmallScreen ? 12 : 13),
                        color: Colors.blue.shade700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
