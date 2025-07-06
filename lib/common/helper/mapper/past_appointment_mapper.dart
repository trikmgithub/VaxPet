import '../../../data/appointment/models/past_appointment.dart';
import '../../../domain/appointment/entities/past_appointment.dart';

class PastAppointmentMapper {
  static PastAppointmentEntity toEntity(PastAppointmentModel appointment) {
    return PastAppointmentEntity(
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
