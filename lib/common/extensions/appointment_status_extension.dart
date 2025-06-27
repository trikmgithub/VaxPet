import 'package:vaxpet/common/enums/appointment_status_enum.dart';

extension AppointmentStatusExtension on int {
  AppointmentStatusEnum? get toAppointmentStatus {
    switch (this) {
      case 1:
        return AppointmentStatusEnum.Processing;
      case 2:
        return AppointmentStatusEnum.Confirmed;
      case 3:
        return AppointmentStatusEnum.CheckedIn;
      case 4:
        return AppointmentStatusEnum.Injected;
      case 5:
        return AppointmentStatusEnum.Implanted;
      case 6:
        return AppointmentStatusEnum.Paid;
      case 7:
        return AppointmentStatusEnum.Applied;
      case 8:
        return AppointmentStatusEnum.Done;
      case 9:
        return AppointmentStatusEnum.Completed;
      case 10:
        return AppointmentStatusEnum.Cancelled;
      case 11:
        return AppointmentStatusEnum.Rejected;
      default:
        return null;
    }
  }

  String? get toAppointmentStatusString {
    final appointmentStatus = toAppointmentStatus?.name;
    switch (appointmentStatus) {
      case 'Processing':
        return 'Đang xử lý';
      case 'Confirmed':
        return 'Đã xác nhận';
      case 'CheckedIn':
        return 'Đã đến';
      case 'Injected':
        return 'Đã tiêm';
      case 'Implanted':
        return 'Đã cấy ghép';
      case 'Paid':
        return 'Đã thanh toán';
      case 'Applied':
        return 'Đã áp dụng';
      case 'Done':
        return 'Hoàn thành';
      case 'Completed':
        return 'Hoàn tất';
      case 'Cancelled':
        return 'Đã hủy';
      case 'Rejected':
        return 'Đã từ chối';
      default:
        return null;
    }
  }
}