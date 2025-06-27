import '../../../data/appointment/models/future_appointment.dart';
import '../../../domain/appointment/entities/future_appointment.dart';

class FutureAppointmentMapper {
  static FutureAppointmentEntity toEntity(FutureAppointmentModel appointment) {
    return FutureAppointmentEntity(
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