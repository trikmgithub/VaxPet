import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/common/helper/message/display_message.dart';
import '../bloc/appointment_health_certificate_note_detail_cubit.dart';
import '../bloc/appointment_health_certificate_note_detail_state.dart';
import '../bloc/appointment_health_certificate_note_cancel_cubit.dart';
import '../bloc/appointment_health_certificate_note_cancel_state.dart';
import '../bloc/appointment_health_certificate_note_detail_edit_cubit.dart';
import '../pages/appointment_health_certificate_note_detail_edit.dart';
import 'appointment_reject_reason.dart';

class AppointmentHealthCertificateDetail extends StatelessWidget {
  const AppointmentHealthCertificateDetail({super.key});

  String _getServiceTypeText(int serviceType) {
    if (serviceType == 3) {
      return 'Chứng nhận sức khỏe';
    } else {
      return 'Dịch vụ khác';
    }
  }

  String _getLocationText(int location) {
    return location == 1 ? 'Trung tâm' : 'Lỗi';
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

  String _getAppointmentStatusText(int appointmentStatus) {
    switch (appointmentStatus) {
      case 1:
        return 'Chờ xác nhận';
      case 2:
        return 'Đã xác nhận';
      case 3:
        return 'Đã đến';
      case 4:
        return 'Đã xử lý';
      case 5:
        return 'Đã thanh toán';
      case 9:
        return 'Đã hoàn thành';
      case 10:
        return 'Đã hủy';
      case 11:
        return 'Đã từ chối';
      default:
        return 'Không xác định';
    }
  }

  Color _getAppointmentStatusColor(int appointmentStatus) {
    switch (appointmentStatus) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.pinkAccent;
      case 5:
        return Colors.teal;
      case 9:
        return Colors.green;
      case 10:
        return Colors.red;
      case 11:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getAppointmentStatusIcon(int appointmentStatus) {
    switch (appointmentStatus) {
      case 1:
        return Icons.schedule;
      case 2:
        return Icons.check_circle;
      case 3:
        return Icons.login;
      case 4:
        return Icons.hourglass_empty;
      case 5:
        return Icons.payment;
      case 9:
        return Icons.check_circle_outline;
      case 10:
        return Icons.cancel;
      case 11:
        return Icons.block;
      default:
        return Icons.help_outline;
    }
  }

  String _calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty) return 'Chưa có';
    try {
      final birthDate = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      final age = now.difference(birthDate);
      final years = (age.inDays / 365).floor();
      final months = ((age.inDays % 365) / 30).floor();

      if (years > 0) {
        return '$years năm';
      } else if (months > 0) {
        return '$months tháng';
      } else {
        return '${age.inDays} ngày';
      }
    } catch (e) {
      return dateOfBirth;
    }
  }

  String _formatBirthDate(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty) return 'Chưa có';
    try {
      final date = DateTime.parse(dateOfBirth);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateOfBirth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      AppointmentHealthCertificateNoteDetailCubit,
      AppointmentHealthCertificateNoteDetailState
    >(
      builder: (context, state) {
        if (state.status == AppointmentHealthCertificateNoteDetailStatus.loading) {
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
            AppointmentHealthCertificateNoteDetailStatus.failure) {
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
                ),
              ],
            ),
          );
        } else if (state.status ==
            AppointmentHealthCertificateNoteDetailStatus.success) {
          return state.appointmentDetail!.fold(
            (error) => Center(
              child: Text(
                'Không thể tải dữ liệu: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            (appointmentData) {
              // Add null safety checks
              if (appointmentData == null) {
                return Center(
                  child: Text(
                    'Dữ liệu lịch hẹn không hợp lệ',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final appointmentDetail = appointmentData['data'];
              if (appointmentDetail == null) {
                return Center(
                  child: Text(
                    'Không tìm thấy thông tin lịch hẹn',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              // Extract appointment, customer, and pet from the nested structure
              final appointment = appointmentDetail['appointment'];
              if (appointment == null) {
                return Center(
                  child: Text(
                    'Không tìm thấy thông tin cuộc hẹn',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final customer = appointment['customerResponseDTO'];
              final pet = appointment['petResponseDTO'];

              if (customer == null || pet == null) {
                return Center(
                  child: Text(
                    'Thông tin khách hàng hoặc thú cưng không đầy đủ',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              // Merge appointment detail with appointment info for consistency
              final mergedAppointment = <String, dynamic>{
                ...Map<String, dynamic>.from(appointmentDetail),
                ...Map<String, dynamic>.from(appointment),
                'appointmentDetailId': appointmentDetail['appointmentDetailId'],
                'appointmentDetailCode': appointmentDetail['appointmentDetailCode'],
                'vetId': appointmentDetail['vetId'],
                'healthConditionId': appointmentDetail['healthConditionId'],
                'note': appointmentDetail['note'],
              };

              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => AppointmentHealthCertificateNoteCancelCubit(),
                  ),
                ],
                child: BlocListener<AppointmentHealthCertificateNoteCancelCubit,
                    AppointmentHealthCertificateNoteCancelState>(
                  listener: (context, cancelState) {
                    if (cancelState.status == AppointmentHealthCertificateNoteCancelStatus.success) {
                      DisplayMessage.successMessage(
                          "Hủy lịch hẹn thành công", context);
                      Navigator.of(context).pop(true);
                    } else if (cancelState.status == AppointmentHealthCertificateNoteCancelStatus.failure) {
                      DisplayMessage.errorMessage(
                          cancelState.errorMessage ?? "Có lỗi xảy ra khi hủy lịch hẹn", context);
                    }
                  },
                  child: _buildAppointmentDetail(
                    context,
                    mergedAppointment,
                    Map<String, dynamic>.from(customer),
                    Map<String, dynamic>.from(pet)
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildAppointmentDetail(
    BuildContext context,
    Map<String, dynamic> appointment,
    Map<String, dynamic> customer,
    Map<String, dynamic> pet,
  ) {
    // Get screen dimensions for responsive design
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? screenWidth * 0.1 : 16.0;

    final appointmentStatus = appointment['appointmentStatus'] as int? ?? 0;
    final canEdit = appointmentStatus == 1; // 1 = Pending
    final canCancel = appointmentStatus == 1; // 1 = Pending

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
              appointment['appointmentCode'] ?? '',
              appointment['appointmentDetailCode'] ?? '',
              isTablet,
            ),

            const SizedBox(height: 20),

            // Pet Information Card at the top
            _buildPetInfoCard(
              context,
              pet['name'] ?? 'Chưa có',
              pet['species'] ?? 'Không xác định',
              pet['breed'] ?? 'Chưa có',
              pet['image'],
              pet['dateOfBirth'],
              pet['weight']?.toString() ?? 'Chưa có',
              pet['gender'] ?? 'Chưa có',
              pet['color'] ?? 'Chưa có',
              pet['nationality'] ?? 'Chưa có',
              pet['isSterilized'] ?? false,
              isTablet,
            ),

            const SizedBox(height: 20),

            // Appointment Information Card
            _buildAppointmentInfoCard(
              context,
              appointment['appointmentDate'] ?? '',
              appointment['serviceType'] ?? 0,
              isTablet,
            ),

            const SizedBox(height: 20),

            // Location Information Card
            _buildLocationCard(
              context,
              appointment['location'] ?? 0,
              appointment['address'] ?? 'Chưa có',
              isTablet
            ),

            const SizedBox(height: 20),

            // Additional Information Card
            _buildAdditionalInfoCard(
              context,
              appointment['createdAt'] ?? '',
              appointment['note'],
              isTablet
            ),

            // Show Reason button for cancelled health certificate appointments (status 10)
            if (appointmentStatus == 10) ...[
              const SizedBox(height: 20),
              _buildReasonButton(context, appointment, isTablet),
            ],

            const SizedBox(height: 32),

            // Action Buttons (only for pending appointments)
            if (canEdit || canCancel)
              _buildActionButtons(context, appointment, isTablet),

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
    String appointmentDetailCode,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.9),
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
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
              color: _getStatusColor(appointmentStatus),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _getStatusColor(appointmentStatus).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(appointmentStatus),
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  _getStatusText(appointmentStatus),
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
            Icons.health_and_safety,
            color: Colors.white,
            size: isTablet ? 48 : 40,
          ),
          const SizedBox(height: 12),
          Text(
            'Lịch hẹn giấy chứng nhận sức khỏe',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: isTablet ? 16 : 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            appointmentCode.isNotEmpty ? appointmentCode : appointmentDetailCode,
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

  Widget _buildPetInfoCard(
    BuildContext context,
    String petName,
    String species,
    String breed,
    String? imageUrl,
    String? dateOfBirth,
    String weight,
    String gender,
    String color,
    String nationality,
    bool isSterilized,
    bool isTablet,
  ) {
    return _buildInfoCard(
      title: 'Thông tin thú cưng',
      icon: Icons.pets,
      iconColor: Colors.green,
      isTablet: isTablet,
      children: [
        if (imageUrl != null && imageUrl.isNotEmpty) ...[
          Center(
            child: Container(
              width: isTablet ? 100 : 80,
              height: isTablet ? 100 : 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  imageUrl,
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
          value: _getSpeciesText(species),
          isTablet: isTablet,
        ),
        _buildInfoRow(
          icon: Icons.pets,
          label: 'Giống',
          value: breed,
          isTablet: isTablet,
        ),
      ],
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
          icon: Icons.health_and_safety,
          label: 'Dịch vụ',
          value: _getServiceTypeText(serviceType),
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
    String? note,
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
        if (note != null && note.isNotEmpty)
          _buildInfoRow(
            icon: Icons.note,
            label: 'Ghi chú',
            value: note,
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
            color: Colors.grey.withOpacity(0.1),
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
                  color: iconColor.withOpacity(0.1),
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
    Map<String, dynamic> appointment,
    bool isTablet,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final editCubit = AppointmentHealthCertificateNoteDetailEditCubit();

                  final result = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: editCubit,
                        child: AppointmentHealthCertificateNoteDetailEditPage(
                          appointmentData: appointment,
                        ),
                      ),
                    ),
                  );

                  if (result == true && context.mounted) {
                    // Use appointmentId for consistency with microchip implementation
                    final appointmentId = appointment['appointmentId'];
                    debugPrint('Refreshing with appointmentId: $appointmentId');
                    context
                        .read<AppointmentHealthCertificateNoteDetailCubit>()
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
                  _showCancelDialog(context, appointment);
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

  void _showCancelDialog(BuildContext context, Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider(
          create: (context) => AppointmentHealthCertificateNoteCancelCubit(),
          child: BlocListener<AppointmentHealthCertificateNoteCancelCubit,
              AppointmentHealthCertificateNoteCancelState>(
            listener: (context, state) {
              if (state.status == AppointmentHealthCertificateNoteCancelStatus.success) {
                Navigator.of(dialogContext).pop();
                DisplayMessage.successMessage("Hủy lịch hẹn thành công", context);
                Navigator.of(context).pop(true);
              } else if (state.status == AppointmentHealthCertificateNoteCancelStatus.failure) {
                Navigator.of(dialogContext).pop();
                DisplayMessage.errorMessage(
                    state.errorMessage ?? "Có lỗi xảy ra khi hủy lịch hẹn", context);
              }
            },
            child: BlocBuilder<AppointmentHealthCertificateNoteCancelCubit,
                AppointmentHealthCertificateNoteCancelState>(
              builder: (context, state) {
                return AlertDialog(
                  title: const Text('Xác nhận hủy lịch hẹn'),
                  content: const Text(
                    'Bạn có chắc chắn muốn hủy lịch hẹn này? Hành động này không thể hoàn tác.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: state.status == AppointmentHealthCertificateNoteCancelStatus.loading
                          ? null
                          : () => Navigator.of(dialogContext).pop(),
                      child: const Text('Không'),
                    ),
                    ElevatedButton(
                      onPressed: state.status == AppointmentHealthCertificateNoteCancelStatus.loading
                          ? null
                          : () {
                              final appointmentId = appointment['appointmentId'];
                              context
                                  .read<AppointmentHealthCertificateNoteCancelCubit>()
                                  .cancelAppointment(appointmentId);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: state.status == AppointmentHealthCertificateNoteCancelStatus.loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Hủy lịch hẹn', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.pinkAccent;
      case 5:
        return Colors.teal;
      case 9:
        return Colors.green;
      case 10:
        return Colors.red;
      case 11:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(int status) {
    switch (status) {
      case 1:
        return Icons.schedule;
      case 2:
        return Icons.check_circle;
      case 3:
        return Icons.login;
      case 4:
        return Icons.medical_services;
      case 5:
        return Icons.verified;
      case 9:
        return Icons.done_all;
      case 10:
        return Icons.cancel_outlined;
      case 11:
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Chờ xác nhận';
      case 2:
        return 'Đã xác nhận';
      case 3:
        return 'Đã đến';
      case 4:
        return 'Đã xử lý';
      case 5:
        return 'Đã thanh toán';
      case 9:
        return 'Đã hoàn thành';
      case 10:
        return 'Đã hủy';
      case 11:
        return 'Đã từ chối';
      default:
        return 'Không xác định';
    }
  }

  Widget _buildReasonButton(
    BuildContext context,
    Map<String, dynamic> appointment,
    bool isTablet,
  ) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          final appointmentId = appointment['appointmentId'];
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AppointmentRejectReasonPage(
                appointmentId: appointmentId,
              ),
            ),
          );
        },
        icon: Icon(Icons.info_outline, size: isTablet ? 24 : 20),
        label: Text(
          'Xem lý do hủy',
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
    );
  }
}
