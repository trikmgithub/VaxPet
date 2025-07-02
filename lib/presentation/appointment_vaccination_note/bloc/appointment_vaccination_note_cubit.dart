import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:vaxpet/domain/vaccine_appointment_note/usecases/get_vaccine_appointment_note.dart';
import 'package:vaxpet/presentation/appointment_vaccination_note/bloc/appointment_vaccination_note_state.dart';
import 'package:vaxpet/service_locator.dart';

class AppointmentVaccinationNoteCubit extends Cubit<AppointmentVaccinationNoteState> {
  AppointmentVaccinationNoteCubit() : super(const AppointmentVaccinationNoteState());

  // Status 1: Pending confirmation
  // Status 2-11: Confirmed (confirmed, checkedIn, injected, implanted, paid, applied, done, completed, cancelled, rejected)
  Future<void> fetchAppointmentVaccinationNotes(int petId) async {
    emit(state.copyWith(status: AppointmentVaccinationNoteStatus.loading));

    try {
      // Fetch pending appointments (status 1)
      final pendingResult = await sl<GetVaccineAppointmentNoteUseCase>().call(
        params: {
          'petId': petId,
          'status': 1,
        },
      );

      // Fetch all confirmed appointments (status 2-11)
      // We'll need to make multiple calls for each status and combine the results
      List<dynamic> allConfirmedAppointments = [];

      // Status list: 2-confirmed, 3-checkedIn, 4-injected, 5-implanted, 6-paid, 7-applied, 8-done, 9-completed, 10-cancelled, 11-rejected
      final confirmedStatuses = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

      for (int status in confirmedStatuses) {
        try {
          final result = await sl<GetVaccineAppointmentNoteUseCase>().call(
            params: {
              'petId': petId,
              'status': status,
            },
          );

          // If the result is successful, add appointments to the list
          result.fold(
            (failure) {
              // Handle individual status failure - we can log but continue with other statuses
              print('Failed to fetch appointments for status $status: $failure');
            },
            (appointments) {
              if (appointments is List) {
                allConfirmedAppointments.addAll(appointments);
              }
            },
          );
        } catch (e) {
          // Log error for individual status but continue
          print('Error fetching status $status: $e');
        }
      }

      // Sort appointments by date (newest first)
      allConfirmedAppointments.sort((a, b) {
        final dateA = DateTime.tryParse(a['appointmentDate']?.toString() ?? '') ?? DateTime.now();
        final dateB = DateTime.tryParse(b['appointmentDate']?.toString() ?? '') ?? DateTime.now();
        return dateB.compareTo(dateA);
      });

      // Create a successful Either result with the combined appointments
      final confirmedResult = Right(allConfirmedAppointments);

      emit(
        state.copyWith(
          status: AppointmentVaccinationNoteStatus.success,
          pendingAppointments: pendingResult,
          confirmedAppointments: confirmedResult,
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
}
