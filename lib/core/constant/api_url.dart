import 'package:vaxpet/core/constant/enviroment.dart';

class ApiUrl {
  static var baseURL = Environment.API_URL;
  static const apiV = 'api/';

  // AUTH ENDPOINTS
  static const register = '${apiV}auth/register';
  static const login = '${apiV}auth/login';
  static const verifyEmail = '${apiV}auth/verify-email';
  static const verifyOtp = '${apiV}auth/verify-otp';
  static const changePassword =
      '${apiV}auth/reset-password';
  static const forgotPassOTP = '${apiV}auth/send-reset-password-email';
  static const forgotPassword = '${apiV}auth/reset-password-after-forget';

  // CUSTOMER ENDPOINTS
  //Get
  static const getCustomerByAccountId =
      '${apiV}customer/get-customer-by-account-id';
  //Put
  static const putUpdateCustomerByCustomerId =
      '${apiV}customer/update-customer';

  // PET ENDPOINTS
  //Get
  static const getPetByAccountId = '${apiV}pets/get-pets-by-account-id';
  static const getPetById = '${apiV}pets/get-pet-by-id';
  //Delete
  static const deletePetById = '${apiV}pets/delete-pet';
  //Post
  static const createPet = '${apiV}pets/create-pet';
  //Put
  static const putUpdatePet = '${apiV}pets/update-pet-by';

  // APPOINTMENT ENDPOINTS
  //Get
  static const getAppointmentByCustomerAndStatus =
      '${apiV}appointment/get-appointment-by-customer-and-status';
  static const getAppointmentByPetAndStatus =
      '${apiV}appointment/get-appointment-by-pet-and-status';
  static const getAppointmentById = '${apiV}appointment/get-appointment-by-id';
  static const getPastAppointmentByCusId =
      '${apiV}appointment/get-past-appointments-by-customer-id';
  static const getTodayAppointmentByCusId =
      '${apiV}appointment/get-today-appointments-by-customer-id';
  static const getFutureAppointmentByCusId =
      '${apiV}appointment/get-future-appointments-by-customer-id';
  //Post
  static const createAppointmentVaccination =
      '${apiV}appointment/create-appointment-vaccination';
  //Put
  static const putUpdateAppointment = '${apiV}appointment/update-appointment';
  //Delete

  // APPOINTMENT FOR VACCINATION ENDPOINTS
  //Get
  static const getAppointmentForVaccinationByPetIdAndStatus =
      '${apiV}AppointmentForVaccination/get-appointment-vaccination-by-pet-id-and-status';
  static const getAppointmentForVaccinationById =
      '${apiV}AppointmentForVaccination/get-appointment-vaccination-by-id';
  //Post
  static const postAppointmentForVaccination =
      '${apiV}AppointmentForVaccination/create-appointment-vaccination';
  //Put
  static const putUpdateAppointmentForVaccination =
      '${apiV}AppointmentForVaccination/update-appointment-vaccination';

  // APPOINTMENT FOR MICROCHIP ENDPOINTS
  //Get
  static const getAppointmentForMicrochipByPetIdAndStatus =
      '${apiV}AppointmentForMicrochip/get-appointment-microchip-by-pet-id-and-status';
  static const getAppointmentForMicrochipById =
      '${apiV}AppointmentForMicrochip/get-appointment-microchip-by-appointment-id';
  //Post
  static const postAppointmentForMicrochip =
      '${apiV}AppointmentForMicrochip/create-appointment-microchip';
  //Put
  static const putUpdateAppointmentForMicrochip =
      '${apiV}AppointmentForMicrochip/update-appointment-microchip';
  static const putCancelAppointmentForMicrochip =
      '${apiV}AppointmentForMicrochip/update-appointment-microchip';

  // DISEASE ENDPOINTS
  static const getDiseaseByPetId = '${apiV}disease/get-disease-by-pet-id';
  //Get
  static const getDiseaseBySpecies = '${apiV}disease/get-disease-by-species';
  //Post
  //Put
  //Delete

  // VACCINE PROFILES ENDPOINTS
  //Get
  static const getVaccineProfileByPetId =
      '${apiV}vaccineProfiles/getVaccineProfileByPetId';

  // APPOINTMENT FOR HEALTH CERTIFICATE ENDPOINTS
  //Post
  static const postAppointmentForHealthCertificate =
      '${apiV}AppointmentForHealthCondition/create-appointment-healthCondition';
  //Get
  static const getAppointmentForHealthCertificateByPetIdAndStatus =
      '${apiV}AppointmentForHealthCondition/get-appointment-detail-healthCondition-by-pet-and-status';
  static const getAppointmentForHealthCertificateById =
      '${apiV}AppointmentForHealthCondition/get-appointment-detail-healthCondition-by';
  //Put
  static const updateAppointmentForHealthCertificate =
      '${apiV}AppointmentForHealthCondition/update-appointment-for-customer';
  static const cancelAppointmentForHealthCertificate =
      '${apiV}AppointmentForHealthCondition/update-appointment-healthCondition-for-staff';
  // ADDRESS ENDPOINTS
  static const getAddressPetVax= '${apiV}PetVaxLocation/get-coordinates-of-vaxpet';

  // MEMBERSHIP ENDPOINTS
  // Get
  static const getCustomerRankingInfo = '${apiV}membership/get-customer-ranking-info';
  static const getMembershipStatus = '${apiV}membership/get-membership-status';

  // POINT TRANSACTION ENDPOINTS
  // Get
  static const getPointTransactionByCustomerId = '${apiV}pointTransaction/get-point-transaction-by-customer-id';

  // VOUCHER ENDPOINTS
  // Get
  static const getAllVoucher = '${apiV}voucher/get-all-vouchers';
  // Post
  static const postVoucher = '${apiV}voucher/redeem-points-for-voucher';

  // CUSTOMER VOUCHER ENDPOINTS
  // Get
  static const getCustomerVoucher = '${apiV}customerVoucher/get-customer-vouchers-by-customer-id';

  // SERVICE HISTORIES ENDPOINTS
  // Get
  static const getServiceHistories = '${apiV}serviceHistories/get-service-history-by';

  // VACCINATION SCHEDULE ENDPOINTS
  // Get
    static const getVaccineSchedule = '${apiV}vaccinationSchedule/get-vaccination-schedule-by-species';

  // HANDBOOK ENDPOINTS
  // Get
  static const getAllHandbooks = '${apiV}handbook/get-all-handbooks';

  // SUPPORT ENDPOINTS
  // Get
  static const getSupports = '${apiV}supportCategory/get-all-support-categories';

  // FAQ ENDPOINTS
  // Get
  static const getFAQ = '${apiV}faq/get-all-faqs';

}
