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
        return AppointmentStatusEnum.injected;
      case 5:
        return AppointmentStatusEnum.implanted;
      case 6:
        return AppointmentStatusEnum.paid;
      case 7:
        return AppointmentStatusEnum.applied;
      case 8:
        return AppointmentStatusEnum.done;
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
      case 'injected':
        return 'Đã tiêm';
      case 'implanted':
        return 'Đã cấy ghép';
      case 'paid':
        return 'Đã thanh toán';
      case 'applied':
        return 'Đã áp dụng';
      case 'done':
        return 'Hoàn thành';
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