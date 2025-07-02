import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/presentation/home/bloc/pets_cubit.dart';
import 'package:vaxpet/domain/pet/entities/pet.dart';
import 'package:vaxpet/presentation/home/bloc/delete_pet_cubit.dart';
import 'package:vaxpet/presentation/home/bloc/delete_pet_state.dart';
import '../../pet/pages/pet_details.dart';
import '../bloc/pets_state.dart';

String calculateAge(String? dob) {
  if (dob == null || dob.isEmpty) return 'Không rõ';
  try {
    final birthDate = DateTime.parse(dob);
    final today = DateTime.now();

    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    if (age < 1) {
      final difference = today.difference(birthDate).inDays;
      final weeks = (difference / 7).floor();
      if (weeks == 0) {
        return '$age tuổi ($difference ngày)';
      } else {
        return '$age tuổi ($weeks tuần)';
      }
    }

    return '$age tuổi';
  } catch (e) {
    return 'Không rõ';
  }
}

class Pets extends StatelessWidget {
  final int accountId;
  final bool isSmallScreen;

  const Pets({super.key, required this.accountId, this.isSmallScreen = true});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PetsCubit()..getPets(accountId),
        ),
        BlocProvider(
          create: (context) => DeletePetCubit(),
        ),
      ],
      child: BlocListener<DeletePetCubit, DeletePetState>(
        listener: (context, state) {
          if (state is DeletePetSuccess) {
            _showTopNotification(
              context: context,
              message: state.message,
              isSuccess: true,
            );
            context.read<PetsCubit>().refreshPets(accountId);
          } else if (state is DeletePetError) {
            _showTopNotification(
              context: context,
              message: state.message,
              isSuccess: false,
            );
          }
        },
        child: BlocBuilder<PetsCubit, PetsState>(
          builder: (context, state) {
            if (state is PetsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary)
              );
            }
            
            if (state is PetsLoaded) {
              return RefreshIndicator(
                onRefresh: () => _refreshPets(context),
                color: AppColors.primary,
                backgroundColor: Colors.white,
                strokeWidth: 2.5,
                child: state.pets.isEmpty 
                  ? _buildEmptyState()
                  : _buildPetsList(state.pets),
              );
            }
            
            if (state is PetsError) {
              return RefreshIndicator(
                onRefresh: () => _refreshPets(context),
                color: AppColors.primary,
                child: _buildErrorState(state.message),
              );
            }
            
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Widget hiển thị khi không có dữ liệu
  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SizedBox(height: 100),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.pets,
                  size: 64,
                  color: AppColors.primary.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Chưa có thú cưng nào',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Nhấn nút "+" để thêm thú cưng đầu tiên',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget hiển thị khi có lỗi
  Widget _buildErrorState(String message) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SizedBox(height: 100),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Có lỗi xảy ra',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Kéo xuống để thử lại',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget hiển thị danh sách thú cưng
  Widget _buildPetsList(List<PetEntity> pets) {
    if (isSmallScreen) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pets.length,
        itemBuilder: (context, index) {
          return PetCard(
            pet: pets[index],
            isSmallScreen: isSmallScreen,
            deletePetCubit: context.read<DeletePetCubit>(),
          );
        },
      );
    } else {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: pets.length,
        itemBuilder: (context, index) {
          return PetCard(
            pet: pets[index],
            isSmallScreen: isSmallScreen,
            deletePetCubit: context.read<DeletePetCubit>(),
          );
        },
      );
    }
  }

  // Phương thức để làm mới dữ liệu
  Future<void> _refreshPets(BuildContext context) async {
    final petsCubit = context.read<PetsCubit>();
    await petsCubit.refreshPets(accountId);
    return Future.value();
  }

  // Phương thức tạo và hiển thị thông báo ở phía trên màn hình
  void _showTopNotification({
    required BuildContext context,
    required String message,
    bool isSuccess = true,
  }) {
    _removeCurrentNotification(context);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).viewPadding.top + 10,
        left: 10,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSuccess ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        isSuccess ? Icons.check_circle : Icons.error_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _removeCurrentNotification(context),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    _currentNotification = overlayEntry;
    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        _removeCurrentNotification(context);
      }
    });
  }

  // Biến static để theo dõi thông báo hiện tại
  static OverlayEntry? _currentNotification;

  // Xóa thông báo hiện tại nếu có
  void _removeCurrentNotification(BuildContext context) {
    if (_currentNotification != null) {
      _currentNotification!.remove();
      _currentNotification = null;
    }
  }
}

class PetCard extends StatelessWidget {
  final PetEntity pet;
  final bool isSmallScreen;
  final DeletePetCubit deletePetCubit;

  const PetCard({
    super.key,
    required this.pet,
    required this.deletePetCubit,
    this.isSmallScreen = true
  });

  @override
  Widget build(BuildContext context) {
    final Color tagColor = _getPastelColor(pet.species ?? 'Không rõ');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: tagColor.withValues(alpha: 0.1),
        highlightColor: tagColor.withValues(alpha: 0.05),
        onTap: () {
          AppNavigator.push(
            context,
            PetDetailsPage(
              petId: pet.petId!,
              petName: pet.name ?? "Chưa đặt tên",
              petImage: pet.image,
              petSpecies: pet.species ?? "Không rõ",
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Species tag and gender icon
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: tagColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getCuteSpeciesIcon(pet.species ?? 'Không rõ'),
                        size: 16.0,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        pet.species?.toLowerCase() == 'dog' ? 'Chó' : 'Mèo',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  if (pet.gender != null)
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        pet.gender?.toLowerCase() == 'đực'
                            ? Icons.male_rounded
                            : Icons.female_rounded,
                        size: 12.0,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),

            // Avatar and info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: tagColor.withValues(alpha: 0.2),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      image: pet.image != null && pet.image!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(pet.image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: pet.image == null || pet.image!.isEmpty
                        ? ClipOval(child: _buildPlaceholderImage(tagColor))
                        : null,
                  ),

                  const SizedBox(width: 16.0),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name ?? 'Chưa đặt tên',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[850],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cake_rounded, size: 14.0, color: tagColor),
                            const SizedBox(width: 4.0),
                            Text(
                              calculateAge(pet.dateOfBirth),
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: () {
                                  AppNavigator.push(
                                    context,
                                    PetDetailsPage(
                                      petId: pet.petId!,
                                      petName: pet.name ?? "Chưa đặt tên",
                                      petImage: pet.image,
                                      petSpecies: pet.species?.toLowerCase() == "dog" ? "Chó" : "Mèo",
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: tagColor.withValues(alpha: 0.9),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'Chi tiết',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () {
                                  _showDeleteConfirmDialog(context, pet.petId!, pet.name);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade400,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Icon(Icons.delete_outline, size: 20.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(Color themeColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[100]!, Colors.grey[200]!],
        ),
      ),
      child: Center(
        child: Icon(
          _getCuteSpeciesIcon(pet.species ?? 'Không rõ'),
          size: 24,
          color: themeColor.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Color _getPastelColor(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
      case 'chó':
        return AppColors.primary.withValues(alpha: 0.7);
      case 'cat':
      case 'mèo':
        return AppColors.primary.withValues(alpha: 0.7);
      default:
        return AppColors.primary.withValues(alpha: 0.7);
    }
  }

  IconData _getCuteSpeciesIcon(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
      case 'chó':
        return Icons.pets;
      case 'cat':
      case 'mèo':
        return Icons.pets;
      default:
        return Icons.pets;
    }
  }

  void _showDeleteConfirmDialog(BuildContext context, int petId, String? petName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa thú cưng "${petName ?? ''}" không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Xóa',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                deletePetCubit.deletePet(petId);
              },
            ),
          ],
        );
      },
    );
  }
}

