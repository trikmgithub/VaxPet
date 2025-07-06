import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:vaxpet/domain/vaccine_appointment_note/usecases/get_vaccine_appointment_note.dart';
import 'package:vaxpet/presentation/appointment_vaccination_note/bloc/appointment_vaccination_note_state.dart';
import 'package:vaxpet/service_locator.dart';

class AppointmentVaccinationNoteCubit
    extends Cubit<AppointmentVaccinationNoteState> {
  AppointmentVaccinationNoteCubit()
    : super(const AppointmentVaccinationNoteState());

  static const int vaccinationType = 1; // Service type for vaccination

  // Status 1: Pending confirmation
  // Status 2-11: Confirmed (confirmed, checkedIn, injected, implanted, paid, applied, done, completed, cancelled, rejected)
  Future<void> fetchAppointmentVaccinationNotes(int petId) async {
    emit(state.copyWith(status: AppointmentVaccinationNoteStatus.loading));

    try {
      // Fetch pending appointments (status 1)
      final pendingResult = await sl<GetVaccineAppointmentNoteUseCase>().call(
        params: {'petId': petId, 'status': 1},
      );

      // Fetch all confirmed appointments and organize by actual appointmentStatus
      List<dynamic> allConfirmedAppointments = [];
      Map<int, List<dynamic>> appointmentsByStatus = {};
      List<int> availableStatuses = [];

      // Status list: 2-confirmed, 3-checkedIn, 4-injected, 5-implanted, 6-paid, 7-applied, 8-done, 9-completed, 10-cancelled, 11-rejected
      final confirmedStatuses = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

      for (int status in confirmedStatuses) {
        try {
          final result = await sl<GetVaccineAppointmentNoteUseCase>().call(
            params: {'petId': petId, 'status': status},
          );

          result.fold(
            (failure) {
              print('Failed to fetch appointments for status $status: $failure');
            },
            (appointments) {
              if (appointments is List && appointments.isNotEmpty) {
                // Filter chỉ lấy vaccination appointments
                final vaccinationAppointments = appointments
                    .where((appointment) =>
                        appointment['serviceType'] == vaccinationType)
                    .toList();

                if (vaccinationAppointments.isNotEmpty) {
                  // Sort appointments by date (newest first)
                  vaccinationAppointments.sort((a, b) {
                    final dateA = DateTime.tryParse(
                        a['appointmentDate']?.toString() ?? '') ?? DateTime.now();
                    final dateB = DateTime.tryParse(
                        b['appointmentDate']?.toString() ?? '') ?? DateTime.now();
                    return dateB.compareTo(dateA);
                  });

                  // Lưu trữ theo appointmentStatus thực tế từ API, không phải status parameter
                  for (var appointment in vaccinationAppointments) {
                    final actualStatus = appointment['appointment']?['appointmentStatus'] ?? status;

                    if (!appointmentsByStatus.containsKey(actualStatus)) {
                      appointmentsByStatus[actualStatus] = [];
                      if (!availableStatuses.contains(actualStatus)) {
                        availableStatuses.add(actualStatus);
                      }
                    }

                    appointmentsByStatus[actualStatus]!.add(appointment);
                  }

                  allConfirmedAppointments.addAll(vaccinationAppointments);
                }
              }
            },
          );
        } catch (e) {
          print('Error fetching status $status: $e');
        }
      }

      // Sort all confirmed appointments by date (newest first)
      allConfirmedAppointments.sort((a, b) {
        final dateA = DateTime.tryParse(
            a['appointmentDate']?.toString() ?? '') ?? DateTime.now();
        final dateB = DateTime.tryParse(
            b['appointmentDate']?.toString() ?? '') ?? DateTime.now();
        return dateB.compareTo(dateA);
      });

      // Sort available statuses
      availableStatuses.sort();

      // Sort appointments within each status by date
      for (int status in appointmentsByStatus.keys) {
        appointmentsByStatus[status]!.sort((a, b) {
          final dateA = DateTime.tryParse(
              a['appointmentDate']?.toString() ?? '') ?? DateTime.now();
          final dateB = DateTime.tryParse(
              b['appointmentDate']?.toString() ?? '') ?? DateTime.now();
          return dateB.compareTo(dateA);
        });
      }

      // Debug: Print appointments by status
      print('=== Debug: Appointments by Status ===');
      for (int status in appointmentsByStatus.keys) {
        print('Status $status: ${appointmentsByStatus[status]!.length} appointments');
        for (var appointment in appointmentsByStatus[status]!) {
          print('  - ${appointment['appointment']?['appointmentCode']} (Status: ${appointment['appointment']?['appointmentStatus']})');
        }
      }

      // Create a successful Either result with the combined appointments
      final confirmedResult = Right(allConfirmedAppointments);

      emit(
        state.copyWith(
          status: AppointmentVaccinationNoteStatus.success,
          pendingAppointments: pendingResult,
          confirmedAppointments: confirmedResult,
          appointmentsByStatus: appointmentsByStatus,
          availableStatuses: availableStatuses,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppointmentVaccinationNoteStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Method to refresh appointment data
  Future<void> refreshAppointments(int petId) async {
    await fetchAppointmentVaccinationNotes(petId);
  }

  // Method to set status filter
  void setStatusFilter(int? statusFilter) {
    print('=== Setting Status Filter ===');
    print('Selected status: $statusFilter');
    if (statusFilter != null) {
      final appointments = state.appointmentsByStatus[statusFilter] ?? [];
      print('Appointments for status $statusFilter: ${appointments.length}');
      for (var appointment in appointments) {
        print('  - ${appointment['appointment']?['appointmentCode']} (Status: ${appointment['appointment']?['appointmentStatus']})');
      }
    }
    emit(state.copyWith(selectedStatusFilter: statusFilter));
  }

  // Method to clear filter
  void clearStatusFilter() {
    print('=== Clearing Status Filter ===');
    emit(state.copyWith(clearFilter: true));
  }

  // Method to get appointments for specific status
  List<dynamic> getAppointmentsForStatus(int status) {
    return state.appointmentsByStatus[status] ?? [];
  }

  // Method to get available statuses with appointment counts
  Map<int, int> getStatusCounts() {
    Map<int, int> counts = {};
    for (int status in state.availableStatuses) {
      counts[status] = state.getCountForStatus(status);
    }
    return counts;
  }
}
