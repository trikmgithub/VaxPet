class ApiUrl {

  static const baseURL = 'https://pvms-sqlserver-cpfmbpfnbfeya3bg.southeastasia-01.azurewebsites.net/';
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

  //Post
  static const createPet = '${apiV}pets/create-pet';

  static const updatePet = '${apiV}pets/update-pet';

  // APPOINTMENT ENDPOINTS
  //Get
  //Post
  static const createAppointmentVaccination = '${apiV}appointment/create-appointment-vaccination';
  //Put
  //Delete

}