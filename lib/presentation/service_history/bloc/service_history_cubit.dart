import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/service_history/usecases/get_service_history.dart';
import '../../../service_locator.dart';
import 'service_history_state.dart';

class ServiceHistoryCubit extends Cubit<ServiceHistoryState> {
  ServiceHistoryCubit() : super(ServiceHistoryLoading());

  void getServiceHistory() async {
    try {
      emit(ServiceHistoryLoading());

      // Get customerId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('customerId');

      if (customerId == null) {
        emit(ServiceHistoryError(errorMessage: 'Không tìm thấy thông tin khách hàng'));
        return;
      }

      var returnedData = await sl<GetServiceHistoryUseCase>().call(params: customerId);

      returnedData.fold(
        (error) {
          emit(ServiceHistoryError(errorMessage: error));
        },
        (data) {
          List<ServiceHistoryEntity> serviceHistories = [];

          if (data['data'] != null && data['data'] is List) {
            serviceHistories = (data['data'] as List).map((item) {
              return ServiceHistoryEntity(
                serviceHistoryId: item['serviceHistoryId'],
                appointmentId: item['appointmentId'],
                serviceType: item['serviceType'],
                serviceDate: item['serviceDate'],
                paymentMethod: item['paymentMethod'],
                amount: item['amount']?.toDouble(),
                status: item['status'],
                createdAt: item['createdAt'],
                createdBy: item['createdBy'],
                modifiedAt: item['modifiedAt'],
                modifiedBy: item['modifiedBy'],
                isDeleted: item['isDeleted'],
                customer: item['customer'] != null ? CustomerEntity(
                  customerId: item['customer']['customerId'],
                  accountId: item['customer']['accountId'],
                  membershipId: item['customer']['membershipId'],
                  customerCode: item['customer']['customerCode'],
                  fullName: item['customer']['fullName'],
                  userName: item['customer']['userName'],
                  image: item['customer']['image'],
                  phoneNumber: item['customer']['phoneNumber'],
                  dateOfBirth: item['customer']['dateOfBirth'],
                  gender: item['customer']['gender'],
                  address: item['customer']['address'],
                  currentPoints: item['customer']['currentPoints'],
                  redeemablePoints: item['customer']['redeemablePoints'],
                  totalSpent: item['customer']['totalSpent']?.toDouble(),
                  createdAt: item['customer']['createdAt'],
                  createdBy: item['customer']['createdBy'],
                  modifiedAt: item['customer']['modifiedAt'],
                  modifiedBy: item['customer']['modifiedBy'],
                  isDeleted: item['customer']['isDeleted'],
                  accountResponseDTO: item['customer']['accountResponseDTO'] != null
                    ? AccountResponseDTO(
                        accountId: item['customer']['accountResponseDTO']['accountId'],
                        email: item['customer']['accountResponseDTO']['email'],
                        role: item['customer']['accountResponseDTO']['role'],
                        vetId: item['customer']['accountResponseDTO']['vetId'],
                      )
                    : null,
                ) : null,
                pet: item['pet'] != null ? PetEntity(
                  petId: item['pet']['petId'],
                  customerId: item['pet']['customerId'],
                  petCode: item['pet']['petCode'],
                  name: item['pet']['name'],
                  species: item['pet']['species'],
                  breed: item['pet']['breed'],
                  gender: item['pet']['gender'],
                  dateOfBirth: item['pet']['dateOfBirth'],
                  placeToLive: item['pet']['placeToLive'],
                  placeOfBirth: item['pet']['placeOfBirth'],
                  image: item['pet']['image'],
                  weight: item['pet']['weight'],
                  color: item['pet']['color'],
                  nationality: item['pet']['nationality'],
                  isSterilized: item['pet']['isSterilized'],
                  isDeleted: item['pet']['isDeleted'],
                ) : null,
              );
            }).toList();
          }

          emit(ServiceHistoryLoaded(serviceHistories: serviceHistories));
        },
      );
    } catch (e) {
      emit(ServiceHistoryError(errorMessage: e.toString()));
    }
  }
}
