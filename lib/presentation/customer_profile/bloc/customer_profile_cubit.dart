import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/presentation/customer_profile/bloc/customer_profile_state.dart';
import '../../../domain/customer_profile/usecases/get_customer_profile.dart';
import '../../../service_locator.dart';

class CustomerProfileCubit extends Cubit<CustomerProfileState> {
  CustomerProfileCubit() : super(CustomerProfileLoading());

  Future<void> getCustomerProfile(int accountId) async {
    var returnedData = await sl<GetCustomerProfileUseCase>().call(params: accountId);
    returnedData.fold(
      (error) => emit(CustomerProfileError(errorMessage: error.toString())),
      (data) => emit(CustomerProfileLoaded(customerProfile: data)),
    );
  }

}