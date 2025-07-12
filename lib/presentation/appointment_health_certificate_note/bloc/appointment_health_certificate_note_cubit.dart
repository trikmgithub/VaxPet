import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:vaxpet/domain/health_certificate_appointment_note/usecases/get_health_certificate_appointment_note.dart';
import 'package:vaxpet/presentation/appointment_health_certificate_note/bloc/appointment_health_certificate_note_state.dart';
import 'package:vaxpet/service_locator.dart';

class AppointmentHealthCertificateNoteCubit
    extends Cubit<AppointmentHealthCertificateNoteState> {
  AppointmentHealthCertificateNoteCubit()
    : super(const AppointmentHealthCertificateNoteState());

  static const int healthCertificateType = 2; // Service type for health certificate (changed from 3 to 2)

  void _debugLog(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  // Status 1: Pending confirmation
  // Status 2-11: Confirmed (confirmed, checkedIn, injected, implanted, paid, applied, done, completed, cancelled, rejected)
  Future<void> fetchAppointmentHealthCertificateNotes(int petId) async {
    emit(state.copyWith(status: AppointmentHealthCertificateNoteStatus.loading));

    try {
      // Fetch pending appointments (status 1)
      final pendingResult = await sl<GetHealthCertificateAppointmentNoteUseCase>().call(
        params: {'petId': petId, 'status': 1},
      );

      // Fetch all confirmed appointments and organize by actual appointmentStatus
      List<dynamic> allConfirmedAppointments = [];
      Map<int, List<dynamic>> appointmentsByStatus = {};
      List<int> availableStatuses = [];

      final confirmedStatuses = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

      for (int status in confirmedStatuses) {
        try {
          final result = await sl<GetHealthCertificateAppointmentNoteUseCase>().call(
            params: {'petId': petId, 'status': status},
          );

          result.fold(
            (failure) {
              _debugLog(
                'Failed to fetch appointments for status $status: $failure',
              );
            },
            (appointments) {
              if (appointments is List && appointments.isNotEmpty) {
                // Filter chỉ lấy health certificate appointments
                final healthCertificateAppointments =
                    appointments
                        .where(
                          (appointment) =>
                              appointment['serviceType'] == healthCertificateType,
                        )
                        .toList();

                if (healthCertificateAppointments.isNotEmpty) {
                  // Sort appointments by date (newest first)
                  healthCertificateAppointments.sort((a, b) {
                    final dateA =
                        DateTime.tryParse(
                          a['appointmentDate']?.toString() ?? '',
                        ) ??
                        DateTime.now();
                    final dateB =
                        DateTime.tryParse(
                          b['appointmentDate']?.toString() ?? '',
                        ) ??
                        DateTime.now();
                    return dateB.compareTo(dateA);
                  });

                  // Lưu trữ theo appointmentStatus thực tế từ API, không phải status parameter
                  for (var appointment in healthCertificateAppointments) {
                    final actualStatus =
                        appointment['appointment']?['appointmentStatus'] ??
                        status;

                    if (!appointmentsByStatus.containsKey(actualStatus)) {
                      appointmentsByStatus[actualStatus] = [];
                      if (!availableStatuses.contains(actualStatus)) {
                        availableStatuses.add(actualStatus);
                      }
                    }

                    appointmentsByStatus[actualStatus]!.add(appointment);
                  }

                  allConfirmedAppointments.addAll(healthCertificateAppointments);
                }
              }
            },
          );
        } catch (e) {
          _debugLog('Error fetching status $status: $e');
        }
      }

      // Sort all confirmed appointments by date (newest first)
      allConfirmedAppointments.sort((a, b) {
        final dateA =
            DateTime.tryParse(a['appointmentDate']?.toString() ?? '') ??
            DateTime.now();
        final dateB =
            DateTime.tryParse(b['appointmentDate']?.toString() ?? '') ??
            DateTime.now();
        return dateB.compareTo(dateA);
      });

      // Sort available statuses
      availableStatuses.sort();

      // Sort appointments within each status by date
      for (int status in appointmentsByStatus.keys) {
        appointmentsByStatus[status]!.sort((a, b) {
          final dateA =
              DateTime.tryParse(a['appointmentDate']?.toString() ?? '') ??
              DateTime.now();
          final dateB =
              DateTime.tryParse(b['appointmentDate']?.toString() ?? '') ??
              DateTime.now();
          return dateB.compareTo(dateA);
        });
      }

      // Debug: Print appointments by status
      _debugLog('=== Debug: Appointments by Status ===');
      for (int status in appointmentsByStatus.keys) {
        _debugLog(
          'Status $status: ${appointmentsByStatus[status]!.length} appointments',
        );
        for (var appointment in appointmentsByStatus[status]!) {
          _debugLog(
            '  - ${appointment['appointment']?['appointmentCode']} (Status: ${appointment['appointment']?['appointmentStatus']})',
          );
        }
      }

      // Create properly typed Either results
      final confirmedResult = Right<String, List<dynamic>>(allConfirmedAppointments);

      // Ensure pendingResult has correct type
      final typedPendingResult = pendingResult.fold(
        (failure) => Left<String, List<dynamic>>(failure.toString()),
        (appointments) => Right<String, List<dynamic>>(appointments),
      );

      emit(
        state.copyWith(
          status: AppointmentHealthCertificateNoteStatus.success,
          pendingAppointments: typedPendingResult,
          confirmedAppointments: confirmedResult,
          appointmentsByStatus: appointmentsByStatus,
          availableStatuses: availableStatuses,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppointmentHealthCertificateNoteStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Method to refresh appointment data
  Future<void> refreshAppointments(int petId) async {
    await fetchAppointmentHealthCertificateNotes(petId);
  }

  // Method to set status filter
  void setStatusFilter(int? statusFilter) {
    _debugLog('=== Setting Status Filter ===');
    _debugLog('Selected status: $statusFilter');
    if (statusFilter != null) {
      final appointments = state.appointmentsByStatus[statusFilter] ?? [];
      _debugLog(
        'Appointments for status $statusFilter: ${appointments.length}',
      );
      for (var appointment in appointments) {
        _debugLog(
          '  - ${appointment['appointment']?['appointmentCode']} (Status: ${appointment['appointment']?['appointmentStatus']})',
        );
      }
    }
    emit(state.copyWith(selectedStatusFilter: statusFilter));
  }

  // Method to clear filter
  void clearStatusFilter() {
    _debugLog('=== Clearing Status Filter ===');
    emit(state.copyWith(clearFilter: true));
  }

  // Method to get appointments for specific status
  List<dynamic> getAppointmentsForStatus(int status) {
    return state.appointmentsByStatus[status] ?? [];
  }

  // Method to get available statuses with appointment counts
  Map<int, int> getStatusCounts() {
    final Map<int, int> counts = {};
    for (int status in state.availableStatuses) {
      counts[status] = state.appointmentsByStatus[status]?.length ?? 0;
    }
    return counts;
  }

  // Method to get total appointment count
  int getTotalAppointmentCount() {
    int total = 0;
    for (var appointments in state.appointmentsByStatus.values) {
      total += appointments.length;
    }
    return total;
  }
}
