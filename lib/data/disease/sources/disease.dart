import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:vaxpet/core/constant/api_url.dart';

import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';

abstract class DiseaseService {
  Future<Either> getDiseaseBySpecies(String species);
}

class DiseaseServiceImpl extends DiseaseService {
  @override
  Future<Either> getDiseaseBySpecies(String species) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.getDiseaseBySpecies}/$species',
      );
      return Right(response.data);
    } on DioException catch (e) {
      // Xử lý lỗi một cách chi tiết hơn
      if (e.response != null) {
        // Nếu server trả về response với data
        if (e.response!.data is Map &&
            e.response!.data.containsKey('message')) {
          // Trả về thông báo lỗi từ API
          return Left(e.response!.data['message']);
        } else {
          return Left('Lỗi đăng ký: ${e.response!.statusCode}');
        }
      } else {
        // Nếu không có resp
        return Left('Lỗi kết nối: ${e.message}');
      }
    } catch (e) {
      return Left('Lỗi không xác định: $e');
    }
  }
}
