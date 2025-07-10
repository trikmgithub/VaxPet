class ApiUrl {
  static const baseURL =
      'https://petvax-dva5eufae0brhdgf.eastasia-01.azurewebsites.net/';
  static const apiV = 'api/';

  // AUTH ENDPOINTS
  static const register = '${apiV}auth/register';
  static const login = '${apiV}auth/login';
  static const verifyEmail = '${apiV}auth/verify-email';
  static const verifyOtp = '${apiV}auth/verify-otp';

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
  static const updatePet = '${apiV}pets/update-pet-by';
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
  //Post
  static const postAppointmentForMicrochip =
      '${apiV}AppointmentForMicrochip/create-appointment-microchip';

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
}
