import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/common/helper/message/display_message.dart';
import '../bloc/appointment_microchip_note_detail_cubit.dart';
import '../bloc/appointment_microchip_note_detail_state.dart';
import '../bloc/appointment_microchip_note_cancel_cubit.dart';
import '../bloc/appointment_microchip_note_cancel_state.dart';
import '../bloc/appointment_microchip_note_detail_edit_cubit.dart';
import '../pages/appointment_microchip_note_detail_edit.dart';

class AppointmentMicrochipDetail extends StatelessWidget {
  const AppointmentMicrochipDetail({super.key});

  String _getServiceTypeText(int serviceType) {
    if (serviceType == 2) {
      return 'Cấy Microchip';
    } else {
      return 'Không phải cấy chip';
    }
  }

  String _getLocationText(int location) {
    return location == 1 ? 'Trung tâm' : 'Tại nhà';
  }

  String _getSpeciesText(String species) {
    return species.toLowerCase() == 'dog' ? 'Chó' : 'Mèo';
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      AppointmentMicrochipNoteDetailCubit,
      AppointmentMicrochipNoteDetailState
    >(
      builder: (context, state) {
        if (state.status == AppointmentMicrochipNoteDetailStatus.loading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Đang tải thông tin...',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        } else if (state.status ==
            AppointmentMicrochipNoteDetailStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Có lỗi xảy ra',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage ?? 'Không thể tải thông tin',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Quay lại'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        } else if (state.status ==
                AppointmentMicrochipNoteDetailStatus.success &&
            state.appointmentDetail != null) {
          return state.appointmentDetail!.fold(
            (failure) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    size: 64,
                    color: Colors.orange[300],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Không thể tải chi tiết lịch hẹn',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            (response) {
              final appointment = response['data'];
              return _buildAppointmentDetail(context, appointment);
            },
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Không có dữ liệu',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildAppointmentDetail(BuildContext context, dynamic data) {
    if (data == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Không có dữ liệu lịch hẹn',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    // Get screen dimensions for responsive design
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? screenWidth * 0.1 : 16.0;

    // Access petResponseDTO directly from data (not nested under 'appointment')
    final petResponseDTO = data['petResponseDTO'] as Map<String, dynamic>? ?? {};

    final petName = petResponseDTO['name'] ?? 'Không xác định';
    final petSpecies = petResponseDTO['species'] ?? 'Không xác định';
    final petBreed = petResponseDTO['breed'] ?? 'Không xác định';
    final petImage = petResponseDTO['image'];

    // Access appointment fields directly from data
    final serviceType = data['serviceType'] ?? 0;
    final appointmentDate = data['appointmentDate'] ?? '';
    final appointmentCode = data['appointmentCode'] ?? '';
    final location = data['location'] ?? 0;
    final address = data['address'] ?? 'Không có thông tin';
    final createdAt = data['createdAt'] ?? '';
    final appointmentStatus = data['appointmentStatus'] ?? 0;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge and Header Card
            _buildHeaderCard(
              context,
              appointmentStatus,
              appointmentCode,
              isTablet,
            ),

            const SizedBox(height: 20),

            // Pet Information Card at the top
            _buildPetInfoCard(
              context,
              petName,
              petSpecies,
              petBreed,
              petImage,
              isTablet,
            ),

            const SizedBox(height: 20),

            // Appointment Information Card
            _buildAppointmentInfoCard(
              context,
              appointmentDate,
              serviceType,
              isTablet,
            ),

            const SizedBox(height: 20),

            // Location Information Card
            _buildLocationCard(context, location, address, isTablet),

            const SizedBox(height: 20),

            // Additional Information Card
            _buildAdditionalInfoCard(context, createdAt, isTablet),

            const SizedBox(height: 32),

            // Action Buttons (only for pending appointments)
            if (appointmentStatus == 1)
              _buildActionButtons(context, data, isTablet),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    int appointmentStatus,
    String appointmentCode,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.9),
            AppColors.primary.withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: appointmentStatus == 1 ? Colors.orange : Colors.green,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (appointmentStatus == 1 ? Colors.orange : Colors.green)
                      .withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  appointmentStatus == 1 ? Icons.schedule : Icons.check_circle,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  appointmentStatus == 1 ? 'Đang chờ xác nhận' : 'Đã xác nhận',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Icon(
            Icons.memory,
            color: Colors.white,
            size: isTablet ? 48 : 40,
          ),
          const SizedBox(height: 12),
          Text(
            'Mã lịch hẹn cấy chip',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: isTablet ? 16 : 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            appointmentCode,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentInfoCard(
    BuildContext context,
    String appointmentDate,
    int serviceType,
    bool isTablet,
  ) {
    return _buildInfoCard(
      title: 'Thông tin lịch hẹn',
      icon: Icons.calendar_today,
      iconColor: Colors.blue,
      isTablet: isTablet,
      children: [
        _buildInfoRow(
          icon: Icons.access_time,
          label: 'Ngày hẹn',
          value: _formatDate(appointmentDate),
          isTablet: isTablet,
        ),
        _buildInfoRow(
          icon: Icons.schedule,
          label: 'Thời gian',
          value: _formatTime(appointmentDate),
          isTablet: isTablet,
        ),
        _buildInfoRow(
          icon: Icons.memory,
          label: 'Dịch vụ',
          value: _getServiceTypeText(serviceType),
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildPetInfoCard(
    BuildContext context,
    String petName,
    String petSpecies,
    String petBreed,
    String? petImage,
    bool isTablet,
  ) {
    return _buildInfoCard(
      title: 'Thông tin thú cưng',
      icon: Icons.pets,
      iconColor: Colors.green,
      isTablet: isTablet,
      children: [
        if (petImage != null) ...[
          Center(
            child: Container(
              width: isTablet ? 100 : 80,
              height: isTablet ? 100 : 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  petImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.pets,
                        size: isTablet ? 50 : 40,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        _buildInfoRow(
          icon: Icons.badge,
          label: 'Tên',
          value: petName,
          isTablet: isTablet,
        ),
        _buildInfoRow(
          icon: Icons.category,
          label: 'Loài',
          value: _getSpeciesText(petSpecies),
          isTablet: isTablet,
        ),
        _buildInfoRow(
          icon: Icons.pets,
          label: 'Giống',
          value: petBreed,
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildLocationCard(
    BuildContext context,
    int location,
    String address,
    bool isTablet,
  ) {
    return _buildInfoCard(
      title: 'Địa điểm',
      icon: Icons.location_on,
      iconColor: Colors.red,
      isTablet: isTablet,
      children: [
        _buildInfoRow(
          icon: Icons.place,
          label: 'Địa điểm',
          value: _getLocationText(location),
          isTablet: isTablet,
        ),
        _buildInfoRow(
          icon: Icons.home,
          label: 'Địa chỉ',
          value: address,
          isTablet: isTablet,
          isAddress: true,
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoCard(
    BuildContext context,
    String createdAt,
    bool isTablet,
  ) {
    return _buildInfoCard(
      title: 'Thông tin khác',
      icon: Icons.info,
      iconColor: Colors.purple,
      isTablet: isTablet,
      children: [
        _buildInfoRow(
          icon: Icons.history,
          label: 'Ngày tạo',
          value: _formatDate(createdAt),
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
    required bool isTablet,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: isTablet ? 24 : 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isTablet,
    bool isAddress = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment:
            isAddress ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey[600], size: isTablet ? 22 : 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    dynamic data,
    bool isTablet,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final editCubit = AppointmentMicrochipNoteDetailEditCubit();

                  final result = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder:
                          (context) => BlocProvider.value(
                            value: editCubit,
                            child: AppointmentMicrochipNoteDetailEditPage(
                              appointmentData: data,
                            ),
                          ),
                    ),
                  );

                  if (result == true && context.mounted) {
                    final appointmentId = data['appointmentId'];
                    context
                        .read<AppointmentMicrochipNoteDetailCubit>()
                        .fetchAppointmentDetail(appointmentId);
                  }
                },
                icon: Icon(Icons.edit, size: isTablet ? 24 : 20),
                label: Text(
                  'Chỉnh sửa',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: isTablet ? 16.0 : 14.0,
                    horizontal: isTablet ? 24.0 : 20.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showCancelDialog(context, data);
                },
                icon: Icon(Icons.cancel, size: isTablet ? 24 : 20),
                label: Text(
                  'Hủy lịch hẹn',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: isTablet ? 16.0 : 14.0,
                    horizontal: isTablet ? 24.0 : 20.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context, dynamic data) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider(
          create: (context) => AppointmentMicrochipNoteCancelCubit(),
          child: BlocConsumer<AppointmentMicrochipNoteCancelCubit, AppointmentMicrochipNoteCancelState>(
            listener: (context, state) {
              if (state.isSuccess) {
                Navigator.of(dialogContext).pop();
                DisplayMessage.successMessage(
                  state.successMessage ?? 'Hủy lịch hẹn thành công',
                  context,
                );
                // Refresh the appointment detail
                final appointmentId = data['appointmentId'];
                context
                    .read<AppointmentMicrochipNoteDetailCubit>()
                    .fetchAppointmentDetail(appointmentId);
              } else if (state.isFailure) {
                Navigator.of(dialogContext).pop();
                DisplayMessage.errorMessage(
                  state.errorMessage ?? 'Có lỗi xảy ra khi hủy lịch hẹn',
                  context,
                );
              }
            },
            builder: (context, state) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'Xác nhận hủy',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                content: Text(
                  'Bạn có chắc chắn muốn hủy lịch hẹn này không? Hành động này không thể hoàn tác.',
                  style: const TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: state.isLoading ? null : () => Navigator.of(dialogContext).pop(),
                    child: Text(
                      'Không',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: state.isLoading ? null : () {
                      final appointmentId = data['appointmentId'];
                      context
                          .read<AppointmentMicrochipNoteCancelCubit>()
                          .cancelAppointment(appointmentId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: state.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Có, hủy lịch',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }


}
