import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vaxpet/common/extensions/location_type_extension.dart';
import 'package:vaxpet/common/extensions/service_type_extension.dart';
import '../../appointment_vaccination_note_detail/pages/appointment_vaccination_note_detail.dart';
import '../bloc/appointment_vaccination_note_cubit.dart';
import '../bloc/appointment_vaccination_note_state.dart';

class AppointmentVaccinationNote extends StatefulWidget {
  final int petId;

  const AppointmentVaccinationNote({
    super.key,
    required this.petId,
  });

  @override
  State<AppointmentVaccinationNote> createState() => _AppointmentVaccinationNoteState();
}

class _AppointmentVaccinationNoteState extends State<AppointmentVaccinationNote> with TickerProviderStateMixin {
  late TabController _tabController;
  static const vaccinationType = 1; // Assuming 1 is the serviceType for vaccination

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Fetch vaccine appointments when widget initializes
    context.read<AppointmentVaccinationNoteCubit>().fetchAppointmentVaccinationNotes(widget.petId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentVaccinationNoteCubit, AppointmentVaccinationNoteState>(
      builder: (context, state) {
        return Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Chờ xác nhận'),
                Tab(text: 'Đã xác nhận'),
              ],
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Pending Appointments
                  _buildPendingAppointments(state),

                  // Tab 2: Confirmed Appointments
                  _buildConfirmedAppointments(state),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPendingAppointments(AppointmentVaccinationNoteState state) {
    if (state.status == AppointmentVaccinationNoteStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.status == AppointmentVaccinationNoteStatus.failure) {
      return Center(child: Text('Lỗi: ${state.errorMessage}'));
    } else if (state.pendingAppointments == null) {
      return const Center(child: Text('Không có dữ liệu'));
    } else {
      return state.pendingAppointments!.fold(
        (failure) => Center(child: Text('Lỗi khi tải dữ liệu')),
        (pendingAppointments) {
          // Filter to only include appointments with serviceType == 1
          final filteredAppointments = pendingAppointments.where((appointment) =>
            appointment['serviceType'] == vaccinationType).toList();

          if (filteredAppointments.isEmpty) {
            return const Center(child: Text('Không có lịch hẹn tiêm phòng đang chờ xác nhận'));
          }

          return RefreshIndicator(
            onRefresh: () async => await context.read<AppointmentVaccinationNoteCubit>()
                .refreshAppointments(widget.petId),
            child: ListView.builder(
              itemCount: filteredAppointments.length,
              itemBuilder: (context, index) {
                final appointment = filteredAppointments[index];
                return AppointmentCard(appointment: appointment, isPending: true);
              },
            ),
          );
        },
      );
    }
  }

  Widget _buildConfirmedAppointments(AppointmentVaccinationNoteState state) {
    if (state.status == AppointmentVaccinationNoteStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.status == AppointmentVaccinationNoteStatus.failure) {
      return Center(child: Text('Lỗi: ${state.errorMessage}'));
    } else if (state.confirmedAppointments == null) {
      return const Center(child: Text('Không có dữ liệu'));
    } else {
      return state.confirmedAppointments!.fold(
        (failure) => Center(child: Text('Lỗi khi tải dữ liệu')),
        (confirmedAppointments) {
          // Filter to only include appointments with serviceType == 1
          final filteredAppointments = confirmedAppointments.where((appointment) =>
            appointment['serviceType'] == vaccinationType).toList();

          if (filteredAppointments.isEmpty) {
            return const Center(child: Text('Không có lịch hẹn tiêm phòng đã xác nhận'));
          }

          return RefreshIndicator(
            onRefresh: () async => await context.read<AppointmentVaccinationNoteCubit>()
                .refreshAppointments(widget.petId),
            child: ListView.builder(
              itemCount: filteredAppointments.length,
              itemBuilder: (context, index) {
                final appointment = filteredAppointments[index];
                return AppointmentCard(appointment: appointment, isPending: false);
              },
            ),
          );
        },
      );
    }
  }
}

class AppointmentCard extends StatelessWidget {
  final dynamic appointment;
  final bool isPending;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.isPending,
  });

  String _getServiceTypeText(int serviceType) {
    return serviceType.toServiceTypeExtensionString;
  }

  String? _getLocationText(int location) {
    return location.toLocationTypeString;
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
    final petName = appointment['appointment']['petResponseDTO']['name'] ?? 'Không xác định';
    final petSpecies = appointment['appointment']['petResponseDTO']['species'] ?? 'Không xác định';
    final serviceType = appointment['serviceType'] ?? 0;
    final appointmentDate = appointment['appointmentDate'] ?? '';
    final appointmentCode = appointment['appointment']['appointmentCode'] ?? '';
    final location = appointment['appointment']['location'] ?? 0;
    final appointmentId = appointment['appointmentId'];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Mã lịch hẹn: $appointmentCode',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    isPending ? 'Chờ xác nhận' : 'Đã xác nhận',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: isPending ? Colors.orange : Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Ngày hẹn: ${_formatDate(appointmentDate)}'),
            const SizedBox(height: 4),
            Text('Thời gian: ${_formatTime(appointmentDate)}'),
            const SizedBox(height: 4),
            Text('Tên thú cưng: $petName'),
            const SizedBox(height: 4),
            Text('Loài: ${_getSpeciesText(petSpecies)}'),
            const SizedBox(height: 4),
            Text('Loại dịch vụ: ${_getServiceTypeText(serviceType)}'),
            const SizedBox(height: 4),
            Text('Địa điểm: ${_getLocationText(location)}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isPending) {
                      // Navigate to detail page for pending appointments
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentVaccinationNoteDetailPage(
                            appointmentId: appointmentId,
                          ),
                        ),
                      );
                    } else {
                      // Show dialog for confirmed appointments
                      _showAppointmentDetails(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(isPending ? 'Xem chi tiết' : 'Xem chi tiết'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _getSpeciesText(String species) {
    return species.toLowerCase() == 'dog' ? 'Chó' : 'Mèo';
  }

  void _showAppointmentDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chi tiết lịch hẹn tiêm phòng'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Thông tin chủ nuôi:',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text('Mã lịch hẹn: ${appointment['appointment']['appointmentCode'] ?? ''}'),
              const SizedBox(height: 8),
              Text('Trạng thái: ${isPending ? 'Đang chờ xác nhận' : 'Đã xác nhận'}'),
              const SizedBox(height: 8),
              Text('Ngày tạo: ${_formatDate(appointment['createdAt'] ?? '')}'),
              const SizedBox(height: 8),
              Text('Ngày hẹn: ${_formatDate(appointment['createdAt'] ?? '')}'),
              const SizedBox(height: 8),
              Text('Thú cưng: ${appointment['appointment']['petResponseDTO']['name'] ?? 'Không xác định'}'),
              const SizedBox(height: 8),
              Text('Loài: ${_getSpeciesText(appointment['appointment']['petResponseDTO']['species'])}'),
              const SizedBox(height: 8),
              Text('Giống: ${appointment['appointment']['petResponseDTO']['breed'] ?? 'Không xác định'}'),
              const SizedBox(height: 8),
              Text('Địa điểm: ${_getLocationText(appointment['appointment']['location'] ?? 0)}'),
              const SizedBox(height: 8),
              Text('Địa chỉ: ${appointment['appointment']['address'] ?? 'Không có thông tin'}'),
              const SizedBox(height: 8),
              Text('Dịch vụ: ${_getServiceTypeText(appointment['appointment']['serviceType'] ?? 0)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
