abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationUpdated extends NotificationState {
  final int appointmentCount;

  NotificationUpdated(this.appointmentCount);
}
