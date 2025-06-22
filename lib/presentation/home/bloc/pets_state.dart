import 'package:vaxpet/domain/pet/entities/pet.dart';

abstract class PetsState {}

class PetsLoading extends PetsState {}

class PetsLoaded extends PetsState {
  final List<PetEntity> pets;
  final int currentPage;
  final int totalPages;
  final int itemsPerPage;

  PetsLoaded({
    required this.pets,
    this.currentPage = 1,
    this.totalPages = 1,
    this.itemsPerPage = 6
  });

  // Helper để lấy pets cho trang hiện tại
  List<PetEntity> get petsForCurrentPage {
    if (pets.isEmpty) return [];

    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage > pets.length
        ? pets.length
        : startIndex + itemsPerPage;

    if (startIndex >= pets.length) return [];
    return pets.sublist(startIndex, endIndex);
  }

  // Tạo một state mới khi chuyển trang
  PetsLoaded copyWith({
    List<PetEntity>? pets,
    int? currentPage,
    int? totalPages,
    int? itemsPerPage,
  }) {
    return PetsLoaded(
      pets: pets ?? this.pets,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
    );
  }
}

class PetsError extends PetsState {
  final String message;

  PetsError(this.message);
}
