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

  static const int healthCertificateType = 3; // Service type for health certificate (corrected to match API data)

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
      _debugLog('=== Starting to fetch appointments for petId: $petId ===');

      // Fetch pending appointments (status 1)
      final pendingResult = await sl<GetHealthCertificateAppointmentNoteUseCase>().call(
        params: {'petId': petId, 'status': 1},
      );

      _debugLog('=== Pending appointments fetch completed ===');
      pendingResult.fold(
        (failure) => _debugLog('Pending appointments error: $failure'),
        (appointments) => _debugLog('Raw pending appointments count: ${appointments?.length ?? 0}'),
      );

      // Fetch all confirmed appointments and organize by actual appointmentStatus
      List<dynamic> allConfirmedAppointments = [];
      Map<int, List<dynamic>> appointmentsByStatus = {};
      List<int> availableStatuses = [];

      final confirmedStatuses = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

      for (int status in confirmedStatuses) {
        try {
          _debugLog('=== Fetching status $status ===');
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
              _debugLog('Raw appointments for status $status: ${appointments?.length ?? 0}');

              if (appointments is List && appointments.isNotEmpty) {
                // Debug: Print all raw appointments
                for (int i = 0; i < appointments.length; i++) {
                  final appointment = appointments[i];
                  _debugLog('  Raw appointment $i:');
                  _debugLog('    - Root serviceType: ${appointment['serviceType']}');
                  _debugLog('    - Nested serviceType: ${appointment['appointment']?['serviceType']}');
                  _debugLog('    - Root appointmentStatus: ${appointment['appointmentStatus']}');
                  _debugLog('    - Nested appointmentStatus: ${appointment['appointment']?['appointmentStatus']}');
                  _debugLog('    - appointmentDetailCode: ${appointment['appointmentDetailCode']}');
                  _debugLog('    - appointmentCode: ${appointment['appointment']?['appointmentCode']}');
                }

                // Filter chỉ lấy health certificate appointments
                // Check serviceType at both root level and nested appointment level
                final healthCertificateAppointments =
                    appointments
                        .where(
                          (appointment) {
                            // Check serviceType at root level first
                            final rootServiceType = appointment['serviceType'];
                            // Also check serviceType in nested appointment object
                            final nestedServiceType = appointment['appointment']?['serviceType'];

                            final isHealthCertificate = rootServiceType == healthCertificateType ||
                                   nestedServiceType == healthCertificateType;

                            _debugLog('    Filtering appointment ${appointment['appointmentDetailCode']}: rootServiceType=$rootServiceType, nestedServiceType=$nestedServiceType, isHealthCertificate=$isHealthCertificate');

                            return isHealthCertificate;
                          },
                        )
                        .toList();

                _debugLog('Filtered health certificate appointments for status $status: ${healthCertificateAppointments.length}');

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

                  // Lưu trữ theo appointmentStatus thực tế từ API
                  for (var appointment in healthCertificateAppointments) {
                    // Get status from root level first, then from nested appointment, then fallback to parameter
                    final actualStatus = appointment['appointmentStatus'] ??
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

      // Process pending appointments with the same filtering logic
      final processedPendingResult = pendingResult.fold(
        (failure) => Left<String, List<dynamic>>(failure.toString()),
        (appointments) {
          if (appointments is List) {
            _debugLog('=== Processing Pending Appointments ===');
            _debugLog('Raw pending appointments: ${appointments.length}');

            // Debug: Print all raw pending appointments
            for (int i = 0; i < appointments.length; i++) {
              final appointment = appointments[i];
              _debugLog('  Raw pending appointment $i:');
              _debugLog('    - Root serviceType: ${appointment['serviceType']}');
              _debugLog('    - Nested serviceType: ${appointment['appointment']?['serviceType']}');
              _debugLog('    - Root appointmentStatus: ${appointment['appointmentStatus']}');
              _debugLog('    - Nested appointmentStatus: ${appointment['appointment']?['appointmentStatus']}');
              _debugLog('    - appointmentDetailCode: ${appointment['appointmentDetailCode']}');
              _debugLog('    - appointmentCode: ${appointment['appointment']?['appointmentCode']}');
            }

            // Filter pending appointments for health certificate service type
            final healthCertificatePending = appointments
                .where((appointment) {
                  final rootServiceType = appointment['serviceType'];
                  final nestedServiceType = appointment['appointment']?['serviceType'];

                  final isHealthCertificate = rootServiceType == healthCertificateType ||
                         nestedServiceType == healthCertificateType;

                  _debugLog('    Filtering pending appointment ${appointment['appointmentDetailCode']}: rootServiceType=$rootServiceType, nestedServiceType=$nestedServiceType, isHealthCertificate=$isHealthCertificate');

                  return isHealthCertificate;
                })
                .toList();

            // Sort by date (newest first)
            healthCertificatePending.sort((a, b) {
              final dateA = DateTime.tryParse(a['appointmentDate']?.toString() ?? '') ?? DateTime.now();
              final dateB = DateTime.tryParse(b['appointmentDate']?.toString() ?? '') ?? DateTime.now();
              return dateB.compareTo(dateA);
            });

            _debugLog('=== Debug: Pending Appointments ===');
            _debugLog('Total pending health certificate appointments: ${healthCertificatePending.length}');
            for (var appointment in healthCertificatePending) {
              final appointmentCode = appointment['appointment']?['appointmentCode'] ??
                                    appointment['appointmentDetailCode'] ??
                                    'Unknown';
              _debugLog('  - $appointmentCode (Service Type: ${appointment['serviceType']})');
            }

            return Right<String, List<dynamic>>(healthCertificatePending);
          }
          return Right<String, List<dynamic>>([]);
        },
      );

      // Create properly typed Either results
      final confirmedResult = Right<String, List<dynamic>>(allConfirmedAppointments);

      emit(
        state.copyWith(
          status: AppointmentHealthCertificateNoteStatus.success,
          pendingAppointments: processedPendingResult,
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
