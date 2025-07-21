import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/address_vax_pet/usecases/get_address_vax_pet.dart';
import '../../../service_locator.dart';
import 'get_address_vax_pet_state.dart';

class GetAddressVaxPetCubit extends Cubit<GetAddressVaxPetState> {
  GetAddressVaxPetCubit() : super(GetAddressVaxPetInitial());

  void getAddressVaxPet() async {
    emit(GetAddressVaxPetLoading());

    try {
      Either result = await sl<GetAddressVaxPetUseCase>().call();

      result.fold(
        (error) {
          emit(GetAddressVaxPetFailure(error.toString()));
        },
        (data) {
          // Kiểm tra nếu data là Map, nếu không thì tạo Map mặc định
          Map<String, dynamic> addressData;
          if (data is Map<String, dynamic>) {
            addressData = data;
          } else {
            // Nếu API trả về dữ liệu khác format, tạo dữ liệu mặc định
            addressData = {
              'latitude': 10.840846,
              'longitude': 106.777707,
              'clinicName': 'VaxPet Veterinary Center',
              'address': '123 Nguyễn Văn Linh, Phường Tân Phong, Quận 7, TP.HCM',
              'phone': '028 3888 9999',
              'openingHours': '8:00 - 12:00 & 13:00-17:00 (Thứ 2 - Chủ nhật)',
            };
          }
          emit(GetAddressVaxPetSuccess(addressData));
        },
      );
    } catch (e) {
      emit(GetAddressVaxPetFailure('Lỗi không xác định: $e'));
    }
  }
}
