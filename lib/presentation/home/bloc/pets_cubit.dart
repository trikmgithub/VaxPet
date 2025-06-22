import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/presentation/home/bloc/pets_state.dart';

import '../../../domain/pet/usecases/get_pets.dart';
import '../../../service_locator.dart';

class PetsCubit extends Cubit<PetsState> {
  PetsCubit() : super(PetsLoading());

  // Số lượng thú cưng hiển thị trên mỗi trang
  final int _itemsPerPage = 6;

  // Phương thức lấy tất cả thú cưng và thiết lập pagination
  void getPets(int accountId) async {
    emit(PetsLoading());

    try {
      final result = await sl<GetPetsUseCase>().call(params: accountId);

      result.fold(
        (error) {
          emit(PetsError(error));
        },
        (data) {
          // Tính toán số trang dựa trên số lượng thú cưng và số lượng hiển thị trên mỗi trang
          final int totalPages = (data.length / _itemsPerPage).ceil();
          emit(PetsLoaded(
            pets: data,
            currentPage: 1,
            totalPages: totalPages > 0 ? totalPages : 1,
            itemsPerPage: _itemsPerPage,
          ));
        }
      );
    } catch (e) {
      emit(PetsError(e.toString()));
    }
  }

  // Phương thức để refresh lại danh sách thú cưng
  Future<void> refreshPets(int accountId) async {
    try {
      final currentState = state;

      final result = await sl<GetPetsUseCase>().call(params: accountId);

      result.fold(
        (error) {
          emit(PetsError(error));
        },
        (data) {
          // Tính toán số trang dựa trên số lượng thú cưng mới
          final int totalPages = (data.length / _itemsPerPage).ceil();

          // Nếu đang ở trạng thái PetsLoaded, giữ nguyên trang hiện tại nếu có thể
          if (currentState is PetsLoaded) {
            final int currentPage = currentState.currentPage <= totalPages
                ? currentState.currentPage
                : 1;

            emit(PetsLoaded(
              pets: data,
              currentPage: currentPage,
              totalPages: totalPages > 0 ? totalPages : 1,
              itemsPerPage: _itemsPerPage,
            ));
          } else {
            emit(PetsLoaded(
              pets: data,
              currentPage: 1,
              totalPages: totalPages > 0 ? totalPages : 1,
              itemsPerPage: _itemsPerPage,
            ));
          }
        }
      );
    } catch (e) {
      emit(PetsError(e.toString()));
    }
  }

  // Phương thức chuyển đến trang tiếp theo
  void nextPage() {
    if (state is PetsLoaded) {
      final currentState = state as PetsLoaded;
      if (currentState.currentPage < currentState.totalPages) {
        emit(currentState.copyWith(
          currentPage: currentState.currentPage + 1
        ));
      }
    }
  }

  // Phương thức quay lại trang trước
  void previousPage() {
    if (state is PetsLoaded) {
      final currentState = state as PetsLoaded;
      if (currentState.currentPage > 1) {
        emit(currentState.copyWith(
          currentPage: currentState.currentPage - 1
        ));
      }
    }
  }

  // Phương thức chuyển đến trang cụ thể
  void goToPage(int page) {
    if (state is PetsLoaded) {
      final currentState = state as PetsLoaded;
      if (page >= 1 && page <= currentState.totalPages) {
        emit(currentState.copyWith(
          currentPage: page
        ));
      }
    }
  }
}