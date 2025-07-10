import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

enum AppointmentMicrochipNoteStatus { initial, loading, success, failure }

class AppointmentMicrochipNoteState extends Equatable {
  final AppointmentMicrochipNoteStatus status;
  final Either? pendingAppointments;
  final Either? confirmedAppointments;
  final String? errorMessage;
  final int? selectedStatusFilter;

  // Map để lưu trữ appointments theo từng status
  final Map<int, List<dynamic>> appointmentsByStatus;
  final List<int> availableStatuses; // Danh sách các status có sẵn

  const AppointmentMicrochipNoteState({
    this.status = AppointmentMicrochipNoteStatus.initial,
    this.pendingAppointments,
    this.confirmedAppointments,
    this.errorMessage,
    this.selectedStatusFilter,
    this.appointmentsByStatus = const {},
    this.availableStatuses = const [],
  });

  void _debugLog(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  AppointmentMicrochipNoteState copyWith({
    AppointmentMicrochipNoteStatus? status,
    Either? pendingAppointments,
    Either? confirmedAppointments,
    String? errorMessage,
    int? selectedStatusFilter,
    bool clearFilter = false,
    Map<int, List<dynamic>>? appointmentsByStatus,
    List<int>? availableStatuses,
  }) {
    return AppointmentMicrochipNoteState(
      status: status ?? this.status,
      pendingAppointments: pendingAppointments ?? this.pendingAppointments,
      confirmedAppointments:
          confirmedAppointments ?? this.confirmedAppointments,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedStatusFilter:
          clearFilter
              ? null
              : (selectedStatusFilter ?? this.selectedStatusFilter),
      appointmentsByStatus: appointmentsByStatus ?? this.appointmentsByStatus,
      availableStatuses: availableStatuses ?? this.availableStatuses,
    );
  }

  // Helper method để lấy appointments đã filter
  List<dynamic> get filteredAppointments {
    _debugLog('=== State: Getting Filtered Appointments ===');
    _debugLog('Selected status filter: $selectedStatusFilter');
    _debugLog('Available statuses: $availableStatuses');
    _debugLog(
      'Appointments by status keys: ${appointmentsByStatus.keys.toList()}',
    );

    if (selectedStatusFilter == null) {
      // Trả về tất cả confirmed appointments
      final result =
          confirmedAppointments?.fold(
            (failure) => <dynamic>[],
            (appointments) => List<dynamic>.from(appointments ?? []),
          ) ??
          [];
      _debugLog('No filter - returning all ${result.length} appointments');
      return result;
    }

    // Trả về appointments của status được chọn
    final result = appointmentsByStatus[selectedStatusFilter] ?? [];
    _debugLog(
      'Filter by status $selectedStatusFilter - returning ${result.length} appointments',
    );

    for (var appointment in result) {
      _debugLog(
        '  - ${appointment['appointment']?['appointmentCode']} (Status: ${appointment['appointment']?['appointmentStatus']})',
      );
    }

    return result;
  }

  // Helper method để đếm appointments theo status
  int getCountForStatus(int status) {
    return appointmentsByStatus[status]?.length ?? 0;
  }

  @override
  List<Object?> get props => [
    status,
    pendingAppointments,
    confirmedAppointments,
    errorMessage,
    selectedStatusFilter,
    appointmentsByStatus,
    availableStatuses,
  ];
}
