import 'package:dartz/dartz.dart';
import 'package:vaxpet/domain/pet_record/repositories/pet_record.dart';

import '../../../service_locator.dart';
import '../sources/pet_record.dart';
import '../models/pet_record.dart';

class PetRecordRepositoryImpl extends PetRecordRepository {
  @override
  Future<Either> getPetRecord(int petId) async {
    var returnedData = await sl<PetRecordService>().getPetRecord(petId);
    return returnedData.fold(
      (error) => Left(error.toString()),
      (data) {
        try {
          final List<dynamic> dataList = data['data'];
          final petRecords = dataList
              .map((json) => PetRecordModel.fromJson(json).toEntity())
              .toList();
          return Right(petRecords);
        } catch (e) {
          return Left('Error processing pet record data: $e');
        }
      },
    );
  }
}