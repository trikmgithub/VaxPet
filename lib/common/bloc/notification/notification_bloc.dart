import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/local_notification_service.dart';
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
    // Chỉ gửi thông báo khi số lượng lịch hẹn tăng lên (có lịch hẹn mới)
    if (event.count > 0 && event.count > _previousCount) {
      await LocalNotificationService.showAppointmentNotification(event.count);
    }

    _previousCount = event.count;
    emit(NotificationUpdated(event.count));
  }
}
