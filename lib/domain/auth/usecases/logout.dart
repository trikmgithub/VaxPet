import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/auth.dart';

class LogoutUseCase extends UseCase<bool, void> {
  @override
  Future<bool> call({params}) async {
    return await sl<AuthRepository>().logout();
  }
}