import '../../../data/appointment/models/today_appointment.dart';
import '../../../domain/appointment/entities/today_appointment.dart';

class TodayAppointmentMapper {
  static TodayAppointmentEntity toEntity(TodayAppointmentModel appointment) {
    return TodayAppointmentEntity(
    appointmentId: appointment.appointmentId,
    customerId: appointment.customerId,
    petId: appointment.petId,
    appointmentCode: appointment.appointmentCode,
    appointmentDate: appointment.appointmentDate,
    serviceType: appointment.serviceType,
    locationType: appointment.locationType,
    address: appointment.address,
    appointmentStatus: appointment.appointmentStatus,
    customerName: appointment.customerName,
    petName: appointment.petName,
    petSpecies: appointment.petSpecies,
    petGender: appointment.petGender,
    petImage: appointment.petImage,
    );
  }
}