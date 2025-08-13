import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/local_notification_service.dart';
import '../../../domain/appointment/entities/today_appointment.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  int _previousCount = 0;

  NotificationBloc() : super(NotificationInitial()) {
    on<UpdateAppointmentCount>(_onUpdateAppointmentCount);
  }

  void _onUpdateAppointmentCount(
    UpdateAppointmentCount event,
    Emitter<NotificationState> emit,
  ) async {
    // Lọc chỉ những appointment có status == 1
    final validAppointments = event.appointments.where((appointment) {
      // Kiểm tra appointmentStatus == 1 (status đã được confirm hoặc active)
      if (appointment is TodayAppointmentEntity) {
        return appointment.appointmentStatus == 1;
      }
      // Fallback cho trường hợp Map (nếu có)
      return appointment['appointmentStatus'] == 1;
    }).toList();

    final validCount = validAppointments.length;

    // Chỉ gửi thông báo khi có appointment với status == 1 và số lượng tăng lên
    if (validCount > 0 && validCount > _previousCount) {
      await LocalNotificationService.showAppointmentNotification(validCount);
    }

    _previousCount = validCount;
    emit(NotificationUpdated(validCount));
  }
}
