import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/data/customer_profile/models/customer_profile.dart';
import '../../../domain/customer_profile/usecases/put_customer_profile.dart';
import '../../../service_locator.dart';
import 'customer_profile_edit_state.dart';

class CustomerProfileEditCubit extends Cubit<CustomerProfileEditState> {
  CustomerProfileEditCubit() : super(CustomerProfileEditLoading());

  Future<void> putCustomerProfileEdit(CustomerProfileModel customerProfile) async {
    var returnedData = await sl<PutCustomerProfileUseCase>().call(params: customerProfile);
    returnedData.fold(
          (error) => emit(CustomerProfileEditError(errorMessage: error.toString())),
          (data) => emit(CustomerProfileEditUpdated(customerProfile: data)),
    );
  }

}