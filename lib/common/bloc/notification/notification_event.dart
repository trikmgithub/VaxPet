abstract class NotificationEvent {}

class UpdateAppointmentCount extends NotificationEvent {
  final List<dynamic> appointments; // Thay đổi từ int count thành List appointments

  UpdateAppointmentCount(this.appointments);
}
