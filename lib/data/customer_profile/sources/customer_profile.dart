import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../../core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';
import '../models/customer_profile.dart';

abstract class CustomerProfileService {
  Future<Either> getCustomerProfile(int accountId);
  Future<Either> putCustomerProfile(CustomerProfileModel customerProfile);
}

class CustomerProfileServiceImpl extends CustomerProfileService {
  @override
  Future<Either> getCustomerProfile(int accountId) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getCustomerByAccountId}/$accountId',
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }

  @override
  Future<Either> putCustomerProfile(
    CustomerProfileModel customerProfile,
  ) async {
    try {
      final url =
          '${ApiUrl.putUpdateCustomerByCustomerId}/${customerProfile.customerId}';

      final Map<String, dynamic> formMap = {
        'customerId': customerProfile.customerId.toString(),
        'fullName': customerProfile.fullName,
        'userName': customerProfile.userName,
        'phoneNumber': customerProfile.phoneNumber,
        'dateOfBirth': customerProfile.dateOfBirth,
        'gender': customerProfile.gender,
        'address': customerProfile.address,
      };

      if (customerProfile.image != null && customerProfile.image!.isNotEmpty) {
        formMap['image'] = await MultipartFile.fromFile(
          customerProfile.image!,
          filename: basename(customerProfile.image!),
        );
      }

      final formData = FormData.fromMap(formMap);

      final response = await sl<DioClient>().put(
        url,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi mạng: ${e.message}');
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }
}
