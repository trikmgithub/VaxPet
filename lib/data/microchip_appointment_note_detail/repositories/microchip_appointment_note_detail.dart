import 'package:dartz/dartz.dart';

import '../../../domain/microchip_appointment_note_detail/repositories/microchip_appointment_note_detail.dart';
import '../../../service_locator.dart';
import '../models/put_microchip_appointment_note.dart';
import '../sources/microchip_appointment_note_detail.dart';

class MicrochipAppointmentNoteDetailRepositoryImpl
    extends MicrochipAppointmentNoteDetailRepository {
  @override
  Future<Either> getMicrochipAppointmentNoteDetail(int appointmentId) async {
    var returnedData = await sl<MicrochipAppointmentNoteDetailService>()
        .getMicrochipAppointmentNoteDetail(appointmentId);

    return returnedData.fold(
      (error) => Left(Exception(error.toString())),
      (data) {
        var appointmentDetail = data;
        return Right(appointmentDetail);
      }
    );
  }

  @override
  Future<Either> putMicrochipAppointmentNoteDetail(PutMicrochipAppointmentModel appointmentUpdate) async {
    var returnedData = await sl<MicrochipAppointmentNoteDetailService>().putMicrochipAppointmentNoteDetail(
      appointmentUpdate,
    );

    return returnedData.fold((error) => Left(Exception(error.toString())), (
        data,
        ) {
      return Right(data);
    });
  }

  @override
  Future<Either> getAppointmentDetailForMicrochipById(int appointmentId) async {
    var returnedData = await sl<MicrochipAppointmentNoteDetailService>()
        .getAppointmentDetailForMicrochipById(appointmentId);

    return returnedData.fold(
            (error) => Left(Exception(error.toString())),
            (data) {
          var appointmentDetail = data;
          return Right(appointmentDetail);
        });
  }
}
