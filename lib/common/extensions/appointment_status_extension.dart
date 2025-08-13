import 'package:vaxpet/common/enums/appointment_status_enum.dart';

extension AppointmentStatusExtension on int {
  AppointmentStatusEnum? get toAppointmentStatus {
    switch (this) {
      case 1:
        return AppointmentStatusEnum.processing;
      case 2:
        return AppointmentStatusEnum.confirmed;
      case 3:
        return AppointmentStatusEnum.checkedIn;
      case 4:
        return AppointmentStatusEnum.processed;
      case 5:
        return AppointmentStatusEnum.paid;
      case 9:
        return AppointmentStatusEnum.completed;
      case 10:
        return AppointmentStatusEnum.cancelled;
      case 11:
        return AppointmentStatusEnum.rejected;
      default:
        return null;
    }
  }

  String? get toAppointmentStatusString {
    final appointmentStatus = toAppointmentStatus?.name;
    switch (appointmentStatus) {
      case 'processing':
        return 'Đang xử lý';
      case 'confirmed':
        return 'Đã xác nhận';
      case 'checkedIn':
        return 'Đã đến';
      case 'processed':
        return 'Đang xử lý';
      case 'Paid':
        return 'Đã Thanh toán';
      case 'completed':
        return 'Hoàn tất';
      case 'cancelled':
        return 'Đã hủy';
      case 'rejected':
        return 'Đã từ chối';
      default:
        return null;
    }
  }
}
