import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/common/extensions/appointment_status_extension.dart';
import 'package:vaxpet/common/extensions/location_type_extension.dart';
import 'package:vaxpet/common/extensions/service_type_extension.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/common/bloc/notification/notification_bloc.dart';
import 'package:vaxpet/common/bloc/notification/notification_event.dart';
import '../../../domain/appointment/entities/today_appointment.dart';
import '../bloc/today_appointment_cubit.dart';
import '../bloc/today_appointment_state.dart';

class TodayAppointmentTab extends StatefulWidget {
  const TodayAppointmentTab({super.key});

  @override
  State<TodayAppointmentTab> createState() => _TodayAppointmentTabState();
}

class _TodayAppointmentTabState extends State<TodayAppointmentTab> {
  // Controller để phát hiện khi người dùng cuộn đến cuối danh sách
  final ScrollController _scrollController = ScrollController();
  late TodayAppointmentCubit _appointmentCubit;

  @override
  void initState() {
    super.initState();

    // Thêm listener để theo dõi sự kiện cuộn
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Kiểm tra xem người dùng đã cuộn đến cuối danh sách chưa
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Nếu đã gần cuối danh sách (còn 200px), tải thêm dữ liệu
      _appointmentCubit.loadMoreAppointments();
    }
  }

  // Icon dễ thương cho từng loài
  IconData _getCuteSpeciesIcon(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
      case 'chó':
        return Icons.pets; // Icon chó dễ thương
      case 'cat':
      case 'mèo':
        return Icons.pets;
      default:
        return Icons.favorite;
    }
  }

  // Phương thức dịch loài thú cưng từ tiếng Anh sang tiếng Việt
  String _translatePetSpecies(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
        return 'Chó';
      case 'cat':
        return 'Mèo';
      default:
        return species; // Trả về nguyên bản nếu không tìm thấy bản dịch
    }
  }

  String _translatePetGender(String gender) {
    switch (gender.toLowerCase()) {
      case 'đực':
      case 'male':
        return 'Đực';
      case 'cái':
      case 'female':
        return 'Cái';
      default:
        return gender;
    }
  }

  // Màu pastel dựa vào loài
  Color _getPastelColor(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
      case 'chó':
        return Color(0xFF6FB3D6); // Xanh dương nhạt dễ thương
      case 'cat':
      case 'mèo':
        return Color(0xFF90C290); // Xanh lá nhạt pastel
      default:
        return Color(0xFF8AABFF); // Xanh nhạt mặc định
    }
  }

  // Phương thức tạo placeholder cho avatar
  Widget _buildPetAvatar(String petImage, String petSpecies) {
    final Color themeColor = _getPastelColor(petSpecies);

    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.2),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
        image:
            petImage.isNotEmpty
                ? DecorationImage(
                  image: NetworkImage(petImage),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      child:
          petImage.isEmpty
              ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.grey[100]!, Colors.grey[200]!],
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getCuteSpeciesIcon(petSpecies),
                    size: 24,
                    color: themeColor.withValues(alpha: 0.7),
                  ),
                ),
              )
              : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        _appointmentCubit = TodayAppointmentCubit()..getTodayAppointments();
        return _appointmentCubit;
      },
      child: BlocBuilder<TodayAppointmentCubit, TodayAppointmentState>(
        builder: (context, state) {
          if (state is TodayAppointmentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodayAppointmentError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is TodayAppointmentLoaded ||
              state is TodayAppointmentLoadingMore) {
            // Lấy appointments từ state
            List<TodayAppointmentEntity> appointments = [];
            bool isLoadingMore = false;

            if (state is TodayAppointmentLoaded) {
              appointments = state.appointments;
            } else if (state is TodayAppointmentLoadingMore) {
              appointments = state.appointments;
              isLoadingMore = true;
            }

            // Gửi danh sách lịch hẹn đến notification bloc để kiểm tra status
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final notificationBloc = context.read<NotificationBloc>();
              notificationBloc.add(UpdateAppointmentCount(appointments));
            });

            return _buildAppointmentList(
              appointments,
              isLoadingMore: isLoadingMore,
              onRefresh: () async => _appointmentCubit.refreshAppointments(),
            );
          }

          // Không có dữ liệu - gửi danh sách rỗng
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final notificationBloc = context.read<NotificationBloc>();
            notificationBloc.add(UpdateAppointmentCount([]));
          });

          return const Center(child: Text('Không có dữ liệu'));
        },
      ),
    );
  }

  Widget _buildAppointmentList(
    List<TodayAppointmentEntity> appointments, {
    bool isLoadingMore = false,
    required Future<void> Function() onRefresh,
  }) {
    if (appointments.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        color: AppColors.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 120),
            const Icon(Icons.event_busy, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Không có lịch hẹn nào trong ngày hôm nay',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: appointments.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Hiển thị loading indicator khi đang tải thêm
          if (index == appointments.length && isLoadingMore) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Hiển thị appointment
          final appointment = appointments[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildPetAvatar(
                        appointment.petImage,
                        appointment.petSpecies,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment.petName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${_translatePetSpecies(appointment.petSpecies)} · ${_translatePetGender(appointment.petGender)}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusChip(appointment.appointmentStatus),
                    ],
                  ),
                  const Divider(height: 24),
                  // Tách ngày và giờ hẹn
                  ..._buildDateTimeInfo(appointment.appointmentDate),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.qr_code,
                    'Mã lịch hẹn',
                    appointment.appointmentCode,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.medical_services,
                    'Loại dịch vụ',
                    _getServiceTypeText(appointment.serviceType) ??
                        'Unknown Service',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.location_on,
                    'Địa điểm',
                    _getLocationText(
                          appointment.locationType,
                          appointment.address,
                        ) ??
                        'Unknown Location',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(int status) {
    Color color;
    String label;

    label = status.toAppointmentStatusString ?? 'Unknown Status';

    if (status == 1) {
      color = Colors.orange;
    } else if (status == 2) {
      color = Colors.blue;
    } else if (status == 3) {
      color = Colors.purple;
    } else if (status == 4) {
      color = Colors.pinkAccent;
    } else if (status == 5) {
      color = Colors.teal;
    } else if (status == 9) {
      color = Colors.green;
    } else if (status == 10) {
      color = Colors.red;
    } else if (status == 11) {
      color = Colors.grey;
    } else {
      color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: Colors.grey)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  // Tách ngày và giờ hẹn từ chuỗi ngày giờ
  Map<String, String> _splitDateAndTime(String dateTimeString) {
    // Xử lý chuỗi ngày giờ có định dạng ISO "yyyy-MM-ddTHH:mm:ss"
    String processedString = dateTimeString;

    // Nếu chuỗi có định dạng ISO với ký tự 'T', thay thế 'T' bằng khoảng trắng
    if (dateTimeString.contains('T')) {
      processedString = dateTimeString.replaceAll('T', ' ');
    }

    // Tiếp tục xử lý như trước đây
    List<String> parts = processedString.split(' ');

    if (parts.length >= 2) {
      // Lấy phần ngày
      String datePart = parts[0];
      // Chuyển đổi định dạng ngày từ yyyy-MM-dd sang dd/MM/yyyy nếu cần
      List<String> datePieces = datePart.split('-');
      if (datePieces.length == 3) {
        datePart = '${datePieces[2]}/${datePieces[1]}/${datePieces[0]}';
      }

      // Lấy phần giờ
      String timePart = parts[1];
      // Nếu có định dạng giờ HH:mm:ss, chỉ lấy HH:mm
      timePart = timePart.split(':').take(2).join(':');

      return {'date': datePart, 'time': timePart};
    }

    return {
      'date': processedString,
      'time': '00:00', // Mặc định hiển thị 00:00 nếu không có thông tin giờ
    };
  }

  String? _getServiceTypeText(int serviceType) {
    return serviceType.toServiceTypeExtensionString;
  }

  String? _getLocationText(int location, String address) {
    return location.toLocationTypeString;
  }

  List<Widget> _buildDateTimeInfo(String dateTimeString) {
    Map<String, String> dateTimeParts = _splitDateAndTime(dateTimeString);

    return [
      _buildInfoRow(Icons.calendar_today, 'Ngày hẹn', dateTimeParts['date']!),
      const SizedBox(height: 8),
      _buildInfoRow(Icons.access_time, 'Giờ hẹn', dateTimeParts['time']!),
    ];
  }
}
