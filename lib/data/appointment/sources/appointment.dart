import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:vaxpet/data/appointment/models/update_appointment.dart';
import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class AppointmentService {
  Future<Either> getAppointmentByCustomerAndStatus(
    int customerId,
    String status,
  );
  Future<Either> getAppointmentById(int appointmentId);
  Future<Either> getPastAppointmentByCusId(
    int customerId,
    int pageNumber,
    int pageSize,
  );
  Future<Either> getTodayAppointmentByCusId(
    int customerId,
    int pageNumber,
    int pageSize,
  );
  Future<Either> getFutureAppointmentByCusId(
    int customerId,
    int pageNumber,
    int pageSize,
  );
  Future<Either> putAppointmentById(UpdateAppointmentModel appointmentUpdate);
}

class AppointmentServiceImpl extends AppointmentService {
  @override
  Future<Either> getAppointmentByCustomerAndStatus(
    int customerId,
    String status,
  ) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getAppointmentByCustomerAndStatus}/$customerId/$status',
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> getAppointmentById(int appointmentId) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getAppointmentById}/$appointmentId',
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> putAppointmentById(
    UpdateAppointmentModel appointmentUpdate,
  ) async {
    try {
      final url =
          '${ApiUrl.putUpdateAppointment}/${appointmentUpdate.appointmentId}';

      // Sử dụng JSON body thay vì form data
      final jsonBody = appointmentUpdate.toJson();

      final response = await sl<DioClient>().put(
        url,
        data: jsonBody, // Gửi JSON body
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> getFutureAppointmentByCusId(
    int customerId,
    int pageNumber,
    int pageSize,
  ) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getFutureAppointmentByCusId}/$customerId',
        queryParameters: {'pageNumber': pageNumber, 'pageSize': pageSize},
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> getPastAppointmentByCusId(
    int customerId,
    int pageNumber,
    int pageSize,
  ) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getPastAppointmentByCusId}/$customerId',
        queryParameters: {'pageNumber': pageNumber, 'pageSize': pageSize},
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> getTodayAppointmentByCusId(
    int customerId,
    int pageNumber,
    int pageSize,
  ) async {
    try {
      // Data mẫu JSON response theo cấu trúc API
      final mockResponseData = {
        "code": 200,
        "success": true,
        "message": "Lấy tất cả cuộc hẹn hôm nay thành công.",
        "data": {
          "pageInfo": {
            "page": pageNumber,
            "size": pageSize,
            "sort": null,
            "order": null,
            "totalPage": 2,
            "totalItem": 12
          },
          "searchInfo": {
            "keyWord": null,
            "role": null,
            "status": null,
            "is_Verify": null,
            "is_Delete": null
          },
          "pageData": [
            {
              "appointmentId": 216,
              "customerId": customerId,
              "petId": 40,
              "appointmentCode": "AP436340",
              "appointmentDate": "${DateTime.now().toIso8601String()}",
              "serviceType": 1,
              "location": 1,
              "address": "Đại học FPT TP. Hồ Chí Minh",
              "appointmentStatus": 4,
              "createdAt": "2025-07-23T09:15:33.2540566",
              "createdBy": "System",
              "modifiedAt": "2025-07-23T17:00:21.2080981",
              "modifiedBy": "System",
              "isDeleted": false,
              "customerResponseDTO": {
                "customerId": customerId,
                "accountId": 4,
                "membershipId": 3,
                "customerCode": "C438298",
                "fullName": "Kiều Minh Trí",
                "userName": "Min",
                "image": "https://res.cloudinary.com/drhju8y5y/image/upload/v1753545656/pedivax-images/pedivax_940a8c60-084c-4856-a95c-a7a70f66014a.jpg",
                "phoneNumber": "0966116666",
                "dateOfBirth": "12/01/2002",
                "gender": "Nam",
                "address": "12346, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh",
                "currentPoints": 1000,
                "redeemablePoints": 900,
                "totalSpent": null,
                "createdAt": "2025-06-27T19:16:31.9165595",
                "createdBy": null,
                "modifiedAt": "2025-07-26T23:00:58.1386944",
                "modifiedBy": null,
                "isDeleted": false,
                "accountResponseDTO": {
                  "accountId": 4,
                  "email": "triminhkieuse@gmail.com",
                  "role": 4,
                  "vetId": 0
                },
                "membershipResponseDTO": null
              },
              "petResponseDTO": {
                "petId": 40,
                "customerId": customerId,
                "petCode": "PET311052",
                "name": "Cậu Vàng",
                "species": "Dog",
                "breed": "Shiba",
                "gender": "Đực",
                "dateOfBirth": "2025-06-01",
                "placeToLive": "Sg",
                "placeOfBirth": "Sg",
                "image": "https://res.cloudinary.com/drhju8y5y/image/upload/v1752151112/pedivax-images/pedivax_06b1808b-ca17-4c9c-84f8-0a26af3e33aa.jpg",
                "weight": "5",
                "color": "Vàng",
                "nationality": "Vietnam",
                "isSterilized": true,
                "isDeleted": false
              }
            },
            {
              "appointmentId": 249,
              "customerId": customerId,
              "petId": 50,
              "appointmentCode": "AP433884",
              "appointmentDate": "${DateTime.now().add(Duration(hours: 2)).toIso8601String()}",
              "serviceType": 3,
              "location": 1,
              "address": "Đại học FPT TP. Hồ Chí Minh",
              "appointmentStatus": 1,
              "createdAt": "2025-07-26T10:21:13.568811",
              "createdBy": "System",
              "modifiedAt": null,
              "modifiedBy": null,
              "isDeleted": false,
              "customerResponseDTO": {
                "customerId": customerId,
                "accountId": 4,
                "membershipId": 3,
                "customerCode": "C438298",
                "fullName": "Kiều Minh Trí",
                "userName": "Min",
                "image": "https://res.cloudinary.com/drhju8y5y/image/upload/v1753545656/pedivax-images/pedivax_940a8c60-084c-4856-a95c-a7a70f66014a.jpg",
                "phoneNumber": "0966116666",
                "dateOfBirth": "12/01/2002",
                "gender": "Nam",
                "address": "12346, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh",
                "currentPoints": 1000,
                "redeemablePoints": 900,
                "totalSpent": null,
                "createdAt": "2025-06-27T19:16:31.9165595",
                "createdBy": null,
                "modifiedAt": "2025-07-26T23:00:58.1386944",
                "modifiedBy": null,
                "isDeleted": false,
                "accountResponseDTO": {
                  "accountId": 4,
                  "email": "triminhkieuse@gmail.com",
                  "role": 4,
                  "vetId": 0
                },
                "membershipResponseDTO": null
              },
              "petResponseDTO": {
                "petId": 50,
                "customerId": customerId,
                "petCode": "PET447127",
                "name": "Cậu Bạc",
                "species": "Dog",
                "breed": "Shiba",
                "gender": "Đực",
                "dateOfBirth": "07/04/2025",
                "placeToLive": "Hồ Chí Minh",
                "placeOfBirth": "Hồ Chí Minh",
                "image": "https://res.cloudinary.com/drhju8y5y/image/upload/v1753010474/pedivax-images/pedivax_31249c69-2c41-4999-a85e-afd36df10a34.jpg",
                "weight": "1",
                "color": "Vàng",
                "nationality": "Việt Nam",
                "isSterilized": true,
                "isDeleted": false
              }
            }
          ]
        }
      };

      var response = await sl<DioClient>().get(
        '${ApiUrl.getTodayAppointmentByCusId}/$customerId',
        queryParameters: {'pageNumber': pageNumber, 'pageSize': pageSize},
        // Thêm mock data trong options để test hoặc debug
        options: Options(
          headers: {'Content-Type': 'application/json'},
          extra: {'mockData': mockResponseData},
        ),
      );

      // Trong môi trường development, có thể return mock data thay vì real response
      return Right(mockResponseData);

      // return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }
}
