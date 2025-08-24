import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:vaxpet/core/constant/api_url.dart';
import '../../../core/network/dio_client.dart';
import '../../../domain/pet/entities/pet.dart';
import '../../../service_locator.dart';
import '../models/create_pet_req_params.dart';

abstract class PetService {
  Future<Either> getPets(int accountId);
  Future<Either> getPetById(int petId);
  Future<Either> createPet(CreatePetReqParams params);
  Future<Either> deletePet(int petId);
  Future<Either> updatePet(PetEntity pet);
}

class PetServiceImpl extends PetService {
  @override
  Future<Either> getPets(int accountId) async {
    try {
      final url = '${ApiUrl.getPetByAccountId}/$accountId';

      final response = await sl<DioClient>().get(url);

      return Right(response.data);
    } on DioException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception('An unexpected error occurred'));
    }
  }

  @override
  Future<Either> createPet(CreatePetReqParams params) async {
    try {
      final url = ApiUrl.createPet;

      final formData = FormData();
      formData.fields.addAll([
        MapEntry('customerId', params.customerId.toString()),
        MapEntry('name', params.name),
        MapEntry('species', params.species),
        MapEntry('breed', params.breed),
        MapEntry('gender', params.gender),
        MapEntry('dateOfBirth', params.dateOfBirth),
        MapEntry('placeToLive', params.placeToLive),
        MapEntry('placeOfBirth', params.placeOfBirth),
        MapEntry('weight', params.weight),
        MapEntry('color', params.color),
        MapEntry('nationality', params.nationality),
        MapEntry('isSterilized', params.isSterilized.toString()),
      ]);
      if (params.image != null && params.image!.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              params.image!,
              filename: basename(params.image!),
            ),
          ),
        );
      }
      final response = await sl<DioClient>().post(url, data: formData);

      return Right(response.data);
    } on DioException catch (e) {
      return Left('Lỗi: ${e.response?.data['message']}');
    } catch (e) {
      return Left(Exception('An unexpected error occurred'));
    }
  }

  @override
  Future<Either> deletePet(int petId) async {
    try {
      final url = '${ApiUrl.deletePetById}/$petId';

      final response = await sl<DioClient>().delete(url);

      return Right(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(
          'CreatePet failed [${e.response?.statusCode}]: ${e.response?.data}',
        );
      } else {
        debugPrint('CreatePet DioException: $e');
      }
      return Left(e);
    } catch (e) {
      debugPrint('An unexpected error occurred: $e');
      return Left(Exception('An unexpected error occurred'));
    }
  }

  @override
  Future<Either> getPetById(int petId) async {
    try {
      final url = '${ApiUrl.getPetById}/$petId';

      final response = await sl<DioClient>().get(url);

      return Right(response.data);
    } on DioException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception('An unexpected error occurred'));
    }
  }

  @override
  Future<Either> updatePet(PetEntity pet) async {
    try {
      final url = '${ApiUrl.putUpdatePet}/${pet.petId}';

      // Tạo FormData cho multipart/form-data
      final formData = FormData();
      formData.fields.addAll([
        MapEntry('customerId', pet.customerId.toString()),
        MapEntry('name', pet.name ?? ''),
        MapEntry('species', pet.species ?? ''),
        MapEntry('breed', pet.breed ?? ''),
        MapEntry('gender', pet.gender ?? ''),
        MapEntry('dateOfBirth', pet.dateOfBirth ?? ''),
        MapEntry('placeToLive', pet.placeToLive ?? ''),
        MapEntry('placeOfBirth', pet.placeOfBirth ?? ''),
        MapEntry('weight', pet.weight ?? ''),
        MapEntry('color', pet.color ?? ''),
        MapEntry('nationality', pet.nationality ?? ''),
        MapEntry('isSterilized', pet.isSterilized.toString()),
      ]);

      // Thêm ảnh nếu có
      if (pet.image != null && pet.image!.isNotEmpty) {
        // Kiểm tra xem có phải là file path hay URL
        if (!pet.image!.startsWith('http')) {
          // Nếu là file path, thêm như MultipartFile
          formData.files.add(
            MapEntry(
              'image',
              await MultipartFile.fromFile(
                pet.image!,
                filename: basename(pet.image!),
              ),
            ),
          );
        } else {
          // Nếu là URL, chỉ gửi URL
          formData.fields.add(MapEntry('imageUrl', pet.image!));
        }
      }

      final response = await sl<DioClient>().put(
        url,
        queryParameters: {'petId': pet.petId},
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return Right(response.data);
    } on DioException catch (e) {
      // Debug log for server error
      return Left('Lỗi: ${e.response?.data['message']}');
    } catch (e) {
      return Left(Exception('An unexpected error occurred'));
    }
  }
}
