import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/helps.dart';

class GetFAQUseCase extends UseCase<Either, Map<String, dynamic>?> {
  @override
  Future<Either> call({Map<String, dynamic>? params}) async {
    return await sl<HelpsRepository>().getFAQ(params!);
  }
}