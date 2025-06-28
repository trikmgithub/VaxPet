class ApiUrl {

  static const baseURL = 'https://petvax-dva5eufae0brhdgf.eastasia-01.azurewebsites.net/';
  static const apiV = 'api/';

  // AUTH ENDPOINTS
  static const register = '${apiV}auth/register';
  static const login = '${apiV}auth/login';
  static const verifyEmail = '${apiV}auth/verify-email';
  static const verifyOtp = '${apiV}auth/verify-otp';

  // CUSTOMER ENDPOINTS
  static const getCustomerId = '${apiV}customer/get-customer-by-account-id';

  // PET ENDPOINTS
  //Get
  static const getPetByAccountId = '${apiV}pets/get-pets-by-account-id';
  //Delete
  static const deletePetById = '${apiV}pets/delete-pet';

  //Post
  static const createPet = '${apiV}pets/create-pet';

  static const updatePet = '${apiV}pets/update-pet';

  // APPOINTMENT ENDPOINTS
  //Get
  static const getAppointmentByCustomerAndStatus = '${apiV}appointment/get-appointment-by-customer-and-status';
  static const getAppointmentByPetAndStatus = '${apiV}appointment/get-appointment-by-pet-and-status';
  static const getAppointmentById = '${apiV}appointment/get-appointment-by-id';
  static const getPastAppointmentByCusId = '${apiV}appointment/get-past-appointments-by-customer-id';
  static const getTodayAppointmentByCusId = '${apiV}appointment/get-today-appointments-by-customer-id';
  static const getFutureAppointmentByCusId = '${apiV}appointment/get-future-appointments-by-customer-id';
  //Post
  static const createAppointmentVaccination = '${apiV}appointment/create-appointment-vaccination';
  //Put
  //Delete

  // APPOINTMENT FOR MICROCHIP ENDPOINTS
  //Post
  static const postAppointmentForMicrochip = '${apiV}AppointmentForMicrochip/create-appointment-microchip';

  // DISEASE ENDPOINTS
  static const getDiseaseByPetId = '${apiV}disease/get-disease-by-pet-id';
  //Get
  static const getDiseaseBySpecies = '${apiV}disease/get-disease-by-species';
  //Post
  //Put
  //Delete
}