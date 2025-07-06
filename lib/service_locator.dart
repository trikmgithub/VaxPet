import 'package:get_it/get_it.dart';
import 'package:vaxpet/data/pet/repositories/pet.dart';
import 'package:vaxpet/data/pet/sources/pet.dart';
import 'package:vaxpet/domain/pet/usecases/create_pet.dart';

import 'core/network/dio_client.dart';
import 'data/appointment/repositories/appointment.dart';
import 'data/appointment/sources/appointment.dart';
import 'data/appointment_health_certificate/repositories/appointment_health_certificate.dart';
import 'data/appointment_health_certificate/sources/appointment_health_certificate.dart';
import 'data/appointment_microchip/repositories/appointment_microchip.dart';
import 'data/appointment_microchip/sources/appointment_microchip.dart';
import 'data/appointment_vaccination/repositories/appointment_vaccination.dart';
import 'data/appointment_vaccination/sources/appointment_vaccination.dart';
import 'data/auth/repositories/auth.dart';
import 'data/auth/sources/auth_api_service.dart';
import 'data/customer_profile/repositories/customer_profile.dart';
import 'data/customer_profile/sources/customer_profile.dart';
import 'data/disease/repositories/disease.dart';
import 'data/disease/sources/disease.dart';
import 'data/pet_record/repositories/pet_record.dart';
import 'data/pet_record/sources/pet_record.dart';
import 'data/schedule/repositories/schedule.dart';
import 'data/schedule/sources/schedule.dart';
import 'data/vaccine_appointment_note/repositories/vaccine_appointment_note.dart';
import 'data/vaccine_appointment_note/sources/vaccine_appointment_note.dart';
import 'data/vaccine_appointment_note_detail/repositories/vaccine_appointment_note_detail.dart';
import 'data/vaccine_appointment_note_detail/sources/vaccine_appointment_note_detail.dart';
import 'domain/appointment/repositories/appointment.dart';
import 'domain/appointment/usecases/get_appointment_by_id.dart';
import 'domain/appointment/usecases/get_future_appointment_by_cusid.dart';
import 'domain/appointment/usecases/get_past_appointment_by_cusid.dart';
import 'domain/appointment/usecases/get_today_appointment_by_cusid.dart';
import 'domain/appointment/usecases/put_appointment_by_id.dart';
import 'domain/appointment_health_certificate/repositories/appointment_health_certificate.dart';
import 'domain/appointment_health_certificate/usecases/post_appointment_health_certificate.dart';
import 'domain/appointment_microchip/repositories/appointment_microchip.dart';
import 'domain/appointment_microchip/usecases/post_appointment_microchip.dart';
import 'domain/appointment_vaccination/repositories/appointment_vaccination.dart';
import 'domain/appointment_vaccination/usecases/post_appointment_vaccination.dart';
import 'domain/auth/repositories/auth.dart';
import 'domain/auth/usecases/get_customer_id.dart';
import 'domain/auth/usecases/is_logged_in.dart';
import 'domain/auth/usecases/logout.dart';
import 'domain/auth/usecases/verify_email.dart';
import 'domain/auth/usecases/register.dart';
import 'domain/auth/usecases/signin.dart';
import 'domain/auth/usecases/verify_otp.dart';
import 'domain/customer_profile/repositories/customer_profile.dart';
import 'domain/customer_profile/usecases/get_customer_profile.dart';
import 'domain/customer_profile/usecases/put_customer_profile.dart';
import 'domain/disease/repositories/disease.dart';
import 'domain/disease/usecases/get_disease_by_species.dart';
import 'domain/pet/repositories/pet.dart';
import 'domain/pet/usecases/delete_pet.dart';
import 'domain/pet/usecases/get_pet.dart';
import 'domain/pet/usecases/get_pets.dart';
import 'domain/pet/usecases/put_pet.dart';
import 'domain/pet_record/repositories/pet_record.dart';
import 'domain/pet_record/usecases/get_pet_record.dart';
import 'domain/schedule/repositories/schedule.dart';
import 'domain/schedule/usecases/create_app_vac.dart';
import 'domain/vaccine_appointment_note/repositories/vaccine_appointment_note.dart';
import 'domain/vaccine_appointment_note/usecases/get_vaccine_appointment_note.dart';
import 'domain/vaccine_appointment_note_detail/repositories/vaccine_appointment_note_detail.dart';
import 'domain/vaccine_appointment_note_detail/usecases/get_vaccine_appointment_note_detail.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<DioClient>(DioClient());

  // Services
  sl.registerSingleton<AuthService>(AuthServiceImpl());
  sl.registerSingleton<PetService>(PetServiceImpl());
  sl.registerSingleton<ScheduleService>(ScheduleServiceImpl());
  sl.registerSingleton<DiseaseService>(DiseaseServiceImpl());
  sl.registerSingleton<AppointmentService>(AppointmentServiceImpl());
  sl.registerSingleton<VaccineAppointmentNoteService>(
    VaccineAppointmentNoteServiceImpl(),
  );
  sl.registerSingleton<AppointmentMicrochipService>(
    AppointmentMicrochipServiceImpl(),
  );
  sl.registerSingleton<AppointmentVaccinationService>(
    AppointmentVaccinationServiceImpl(),
  );
  sl.registerSingleton<VaccineAppointmentNoteDetailService>(
    VaccineAppointmentNoteDetailServiceImpl(),
  );
  sl.registerSingleton<CustomerProfileService>(CustomerProfileServiceImpl());
  sl.registerSingleton<PetRecordService>(PetRecordServiceImpl());
  sl.registerSingleton<AppointmentHealthCertificateService>(
    AppointmentHealthCertificateServiceImpl(),
  );

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<PetRepository>(PetRepositoryImpl());
  sl.registerSingleton<ScheduleRepository>(ScheduleRepositoryImpl());
  sl.registerSingleton<DiseaseRepository>(DiseaseRepositoryImpl());
  sl.registerSingleton<AppointmentRepository>(AppointmentRepositoryImpl());
  sl.registerSingleton<VaccineAppointmentNoteRepository>(
    VaccineAppointmentNoteRepositoryImpl(),
  );
  sl.registerSingleton<AppointmentMicrochipRepository>(
    AppointmentMicrochipRepositoryImpl(),
  );
  sl.registerSingleton<AppointmentVaccinationRepository>(
    AppointmentVaccinationRepositoryImpl(),
  );
  sl.registerSingleton<VaccineAppointmentNoteDetailRepository>(
    VaccineAppointmentNoteDetailRepositoryImpl(),
  );
  sl.registerSingleton<CustomerProfileRepository>(
    CustomerProfileRepositoryImpl(),
  );
  sl.registerSingleton<PetRecordRepository>(PetRecordRepositoryImpl());
  sl.registerSingleton<AppointmentHealthCertificateRepository>(
    AppointmentHealthCertificateRepositoryImpl(),
  );

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
  sl.registerSingleton<DeletePetUseCase>(DeletePetUseCase());
  sl.registerSingleton<CreateAppVacUseCase>(CreateAppVacUseCase());
  sl.registerSingleton<GetDiseaseBySpeciesUseCase>(
    GetDiseaseBySpeciesUseCase(),
  );
  sl.registerSingleton<GetVaccineAppointmentNoteUseCase>(
    GetVaccineAppointmentNoteUseCase(),
  );
  sl.registerSingleton<GetAppointmentsByIdUseCase>(
    GetAppointmentsByIdUseCase(),
  );
  sl.registerSingleton<GetFutureAppointmentByCusId>(
    GetFutureAppointmentByCusId(),
  );
  sl.registerSingleton<GetPastAppointmentByCusId>(GetPastAppointmentByCusId());
  sl.registerSingleton<GetTodayAppointmentByCusId>(
    GetTodayAppointmentByCusId(),
  );
  sl.registerSingleton<PostAppointmentMicrochipUseCase>(
    PostAppointmentMicrochipUseCase(),
  );
  sl.registerSingleton<PostAppointmentVaccinationUseCase>(
    PostAppointmentVaccinationUseCase(),
  );
  sl.registerSingleton<GetVaccineAppointmentNoteDetailUseCase>(
    GetVaccineAppointmentNoteDetailUseCase(),
  );
  sl.registerSingleton<GetCustomerProfileUseCase>(GetCustomerProfileUseCase());
  sl.registerSingleton<PutCustomerProfileUseCase>(PutCustomerProfileUseCase());
  sl.registerSingleton<PutAppointmentByIdUseCase>(PutAppointmentByIdUseCase());
  sl.registerSingleton<GetPetUseCase>(GetPetUseCase());
  sl.registerSingleton<PutPetUseCase>(PutPetUseCase());
  sl.registerSingleton<GetPetRecordUseCase>(GetPetRecordUseCase());
  sl.registerSingleton<PostAppointmentHealthCertificateUseCase>(PostAppointmentHealthCertificateUseCase());
}
