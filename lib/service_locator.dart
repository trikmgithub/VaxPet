import 'package:get_it/get_it.dart';

import 'core/network/dio_client.dart';
import 'data/auth/repositories/auth.dart';
import 'data/auth/sources/auth_api_service.dart';
import 'domain/auth/repositories/auth.dart';
import 'domain/auth/usecases/is_logged_in.dart';
import 'domain/auth/usecases/verify_email.dart';
import 'domain/auth/usecases/register.dart';
import 'domain/auth/usecases/signin.dart';
import 'domain/auth/usecases/verify_otp.dart';

final sl = GetIt.instance;

void setupServiceLocator() {

  sl.registerSingleton<DioClient>(DioClient());

  // Services
  sl.registerSingleton<AuthService>(AuthServiceImpl());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  // User Cases
  sl.registerSingleton<RegisterUseCase>(RegisterUseCase());
  sl.registerSingleton<SigninUseCase>(SigninUseCase());
  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());
  sl.registerSingleton<VerifyEmailUseCase>(VerifyEmailUseCase());
  sl.registerSingleton<VerifyOtpUseCase>(VerifyOtpUseCase());
}