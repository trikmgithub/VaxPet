import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/presentation/home/bloc/pets_cubit.dart';
import 'package:vaxpet/domain/pet/entities/pet.dart';
import '../../pet/pages/pet_details.dart';
import '../bloc/pets_state.dart';

class Pets extends StatelessWidget {
  final int accountId;
  const Pets({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider (
      create: (context) => PetsCubit()..getPets(accountId),
      child: BlocBuilder<PetsCubit, PetsState> (
        builder: (context, state) {
          if (state is PetsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PetsLoaded) {
            if (state.pets.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pets, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Không có thú cưng nào', style: TextStyle(fontSize: 16, color: Colors.grey))
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.pets.length,
              itemBuilder: (context, index) {
                final pet = state.pets[index];
                return PetCard(pet: pet);
              },
            );
          }
          if (state is PetsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  final PetEntity pet;

  const PetCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh thú cưng
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: pet.image != null && pet.image!.isNotEmpty
                ? Image.network(
                    pet.image!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[200],
                        child: const Icon(Icons.pets, color: Colors.grey),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: const Icon(Icons.pets, color: Colors.grey),
                  ),
            ),
            const SizedBox(width: 16),

            // Thông tin thú cưng
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên thú cưng
                  Text(
                    pet.name ?? 'Chưa đặt tên',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Tuổi và giống loài
                  Row(
                    children: [
                      const Icon(Icons.cake, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Tuổi: ${pet.age ?? 'Không rõ'}',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Giống loài
                  Row(
                    children: [
                      const Icon(Icons.pets, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        pet.species ?? 'Không rõ',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),

                  // Xem thêm
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        AppNavigator.push(
                          context, PetDetailsPage(),
                        );
                      },
                      child: const Text('Xem chi tiết'),
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
}
