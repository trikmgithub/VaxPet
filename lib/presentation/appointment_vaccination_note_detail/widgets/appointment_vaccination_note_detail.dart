import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vaxpet/common/extensions/service_type_extension.dart';
import '../bloc/appointment_vaccination_note_detail_cubit.dart';
import '../bloc/appointment_vaccination_note_detail_state.dart';

class AppointmentVaccinationDetail extends StatelessWidget {
  const AppointmentVaccinationDetail({super.key});

  String _getServiceTypeText(int serviceType) {
    if (serviceType == 1) {
      return serviceType.toServiceTypeExtensionString;
    } else {
      return 'Không phải tiêm phòng';
    }
  }

  String _getLocationText(int location) {
    switch (location) {
      case 1:
        return 'Trung tâm VaxPet';
      case 2:
        return 'Nhà bạn';
      default:
        return 'Không xác định';
    }
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
    return BlocBuilder<AppointmentVaccinationNoteDetailCubit, AppointmentVaccinationNoteDetailState>(
      builder: (context, state) {
        if (state.status == AppointmentVaccinationNoteDetailStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == AppointmentVaccinationNoteDetailStatus.failure) {
          return Center(child: Text('Lỗi: ${state.errorMessage}'));
        } else if (state.status == AppointmentVaccinationNoteDetailStatus.success && state.appointmentDetail != null) {
          return state.appointmentDetail!.fold(
            (failure) => const Center(child: Text('Không thể tải chi tiết lịch hẹn')),
            (response) {
              // Extract the appointment data from the response
              final appointment = response['data'];
              return _buildAppointmentDetail(context, appointment);
            },
          );
        } else {
          return const Center(child: Text('Không có dữ liệu'));
        }
      },
    );
  }

  Widget _buildAppointmentDetail(BuildContext context, dynamic appointment) {
    if (appointment == null) {
      return const Center(child: Text('Không có dữ liệu lịch hẹn'));
    }

    // Access petResponseDTO safely with null checks
    final petResponseDTO = appointment['petResponseDTO'] as Map<String, dynamic>? ?? {};
    // final customerResponseDTO = appointment['customerResponseDTO'] as Map<String, dynamic>? ?? {};

    final petName = petResponseDTO['name'] ?? 'Không xác định';
    final petSpecies = petResponseDTO['species'] ?? 'Không xác định';
    final petBreed = petResponseDTO['breed'] ?? 'Không xác định';
    // final petGender = petResponseDTO['gender'] ?? 'Không xác định';
    // final petWeight = petResponseDTO['weight'] ?? 'Không xác định';
    // final petDob = petResponseDTO['dateOfBirth'] ?? '';

    // Get customer_profile email from the nested structure
    // final accountResponseDTO = customerResponseDTO['accountResponseDTO'] as Map<String, dynamic>? ?? {};
    // final customerEmail = accountResponseDTO['email'] ?? 'Không có email';

    final serviceType = appointment['serviceType'] ?? 0;
    final appointmentDate = appointment['appointmentDate'] ?? '';
    final appointmentCode = appointment['appointmentCode'] ?? '';
    final location = appointment['location'] ?? 0;
    final address = appointment['address'] ?? 'Không có thông tin';
    final createdAt = appointment['createdAt'] ?? '';
    final appointmentStatus = appointment['appointmentStatus'] ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: appointmentStatus == 1 ? Colors.orange : Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        appointmentStatus == 1 ? 'Đang chờ xác nhận' : 'Đã xác nhận',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mã lịch hẹn: $appointmentCode',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Ngày hẹn: ${_formatDate(appointmentDate)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Thời gian: ${_formatTime(appointmentDate)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.medical_services, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Dịch vụ: ${_getServiceTypeText(serviceType)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin thú cưng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.pets, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Tên: $petName',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.category, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Loài: $petSpecies',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.pets, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Giống: $petBreed',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Địa điểm',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Địa điểm: ${_getLocationText(location)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.home, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Địa chỉ: $address',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin khác',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.history, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Ngày tạo: ${_formatDate(createdAt)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (appointmentStatus == 1) // Only show action buttons for pending appointments
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle appointment modification
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: const Text('Chỉnh sửa lịch hẹn'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle appointment cancellation
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: const Text('Hủy lịch hẹn'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
