import 'package:get_it/get_it.dart';
import 'package:vaxpet/data/pet/repositories/pet.dart';
import 'package:vaxpet/data/pet/sources/pet.dart';
import 'package:vaxpet/domain/pet/usecases/create_pet.dart';

import 'core/network/dio_client.dart';
import 'data/auth/repositories/auth.dart';
import 'data/auth/sources/auth_api_service.dart';
import 'data/schedule/repositories/schedule.dart';
import 'data/schedule/sources/schedule.dart';
import 'domain/auth/repositories/auth.dart';
import 'domain/auth/usecases/get_customer_id.dart';
import 'domain/auth/usecases/is_logged_in.dart';
import 'domain/auth/usecases/logout.dart';
import 'domain/auth/usecases/verify_email.dart';
import 'domain/auth/usecases/register.dart';
import 'domain/auth/usecases/signin.dart';
import 'domain/auth/usecases/verify_otp.dart';
import 'domain/pet/repositories/pet.dart';
import 'domain/pet/usecases/get_pets.dart';
import 'domain/schedule/repositories/schedule.dart';
import 'domain/schedule/usecases/create_app_vac.dart';

final sl = GetIt.instance;

void setupServiceLocator() {

  sl.registerSingleton<DioClient>(DioClient());

  // Services
  sl.registerSingleton<AuthService>(AuthServiceImpl());
  sl.registerSingleton<PetService>(PetServiceImpl());
  sl.registerSingleton<ScheduleService>(ScheduleServiceImpl());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<PetRepository>(PetRepositoryImpl());
  sl.registerSingleton<ScheduleRepository>(ScheduleRepositoryImpl());

  // User Cases
  sl.registerSingleton<RegisterUseCase>(RegisterUseCase());
  sl.registerSingleton<SigninUseCase>(SigninUseCase());
  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());
  sl.registerSingleton<VerifyEmailUseCase>(VerifyEmailUseCase());
  sl.registerSingleton<VerifyOtpUseCase>(VerifyOtpUseCase());
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase());
  sl.registerSingleton<GetCustomerIdUseCase>(GetCustomerIdUseCase());

  sl.registerSingleton<GetPetsUseCase>(GetPetsUseCase());
  sl.registerSingleton<CreatePetUseCase>(CreatePetUseCase());

  sl.registerSingleton<CreateAppVacUseCase>(CreateAppVacUseCase());
}