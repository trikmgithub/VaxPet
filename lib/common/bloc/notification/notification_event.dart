abstract class NotificationEvent {}

class UpdateAppointmentCount extends NotificationEvent {
  final int count;

  UpdateAppointmentCount(this.count);
}
