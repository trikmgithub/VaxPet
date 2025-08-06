import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/tips_pet.dart';

class GetAllHandbooksUseCase extends UseCase<Either, Map<String, dynamic>?> {
  @override
  Future<Either> call({Map<String, dynamic>? params}) async {
    return await sl<TipsPetRepository>().getAllHandbooks(params!);
  }
}