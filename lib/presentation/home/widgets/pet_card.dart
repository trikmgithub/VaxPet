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
    // Thử phân tích với định dạng ISO nếu không phải dd/mm/yyyy
    final birthDate = DateTime.parse(dob);
    final today = DateTime.now();

    // Tính số tuổi
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    // Nếu dưới 1 tuổi, hiển thị theo số tuần
    if (age < 1) {
      // Tính số ngày tuổi
      final difference = today.difference(birthDate).inDays;
      // Chuyển đổi sang tuần (1 tuần = 7 ngày)
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
            // Sử dụng Overlay để hiển thị thông báo phía trên màn hình
            _showTopNotification(
              context: context,
              message: state.message,
              isSuccess: true,
            );

            // Làm mới danh sách thú cưng
            context.read<PetsCubit>().refreshPets(accountId);
          } else if (state is DeletePetError) {
            // Hiển thị thông báo lỗi phía trên màn hình
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
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PetsLoaded) {
              if (state.pets.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => _refreshPets(context),
                  color: AppColors.primary,
                  child: ListView(
                    children: const [
                      SizedBox(
                        height: 200,
                      ), // Cho phép kéo xuống để refresh ngay cả khi không có dữ liệu
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Không có thú cưng nào',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Kéo xuống để làm mới',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Lấy danh sách thú cưng cho trang hiện tại
              final petsToShow = state.petsForCurrentPage;

              // Tạo column chứa danh sách thú cưng và điều khiển phân trang
              return Column(
                children: [
                  // Danh sách thú cưng với RefreshIndicator
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => _refreshPets(context),
                      color: AppColors.primary,
                      child:
                          !isSmallScreen
                              ? _buildGridView(petsToShow, isSmallScreen)
                              : _buildListView(petsToShow, isSmallScreen),
                    ),
                  ),

                  // Điều khiển phân trang
                  _buildPaginationControls(context, state),
                ],
              );
            }
            if (state is PetsError) {
              return RefreshIndicator(
                onRefresh: () => _refreshPets(context),
                color: AppColors.primary,
                child: ListView(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 3),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Kéo xuống để thử lại',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Phương thức để làm mới dữ liệu
  Future<void> _refreshPets(BuildContext context) async {
    final petsCubit = context.read<PetsCubit>();
    await petsCubit.refreshPets(accountId);
    return Future.value();
  }

  // Widget hiển thị danh sách thú cưng dạng lưới (cho màn hình lớn)
  Widget _buildGridView(List<PetEntity> pets, bool isSmallScreen) {
    if (pets.isEmpty) {
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Hiển thị 2 thẻ thú cưng mỗi hàng
        childAspectRatio: 1.75, // Tỷ lệ khung hình
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        return PetCard(pet: pets[index], isSmallScreen: isSmallScreen, deletePetCubit: context.read<DeletePetCubit>());
      },
    );
  }

  // Widget hiển thị danh sách thú cưng dạng danh sách (cho màn hình nhỏ)
  Widget _buildListView(List<PetEntity> pets, bool isSmallScreen) {
    if (pets.isEmpty) {
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        return PetCard(pet: pets[index], isSmallScreen: isSmallScreen, deletePetCubit: context.read<DeletePetCubit>());
      },
    );
  }

  // Widget hiển thị điều khiển phân trang
  Widget _buildPaginationControls(BuildContext context, PetsLoaded state) {
    // Lấy ra cubit để thao tác với các trang
    final petsCubit = context.read<PetsCubit>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, -2),
            blurRadius: 6,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hiển thị thanh tiến trình
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value:
                  state.totalPages > 0
                      ? state.currentPage / state.totalPages
                      : 0,
              backgroundColor: Colors.grey[200],
              color: AppColors.primary,
              minHeight: 4,
            ),
          ),

          const SizedBox(height: 12),

          // Điều khiển phân trang
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Nút quay lại trang đầu tiên
              if (state.totalPages > 2)
                _buildPaginationButton(
                  icon: Icons.first_page,
                  onPressed:
                      state.currentPage > 1
                          ? () => petsCubit.goToPage(1)
                          : null,
                  isActive: state.currentPage > 1,
                  tooltip: 'Trang đầu',
                ),

              // Nút quay lại trang trước
              _buildPaginationButton(
                icon: Icons.chevron_left,
                onPressed:
                    state.currentPage > 1
                        ? () => petsCubit.previousPage()
                        : null,
                isActive: state.currentPage > 1,
                tooltip: 'Trang trước',
              ),

              // Hiển thị trang hiện tại và tổng số trang
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Trang ${state.currentPage}/${state.totalPages}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),

              // Nút chuyển đến trang tiếp theo
              _buildPaginationButton(
                icon: Icons.chevron_right,
                onPressed:
                    state.currentPage < state.totalPages
                        ? () => petsCubit.nextPage()
                        : null,
                isActive: state.currentPage < state.totalPages,
                tooltip: 'Trang kế',
              ),

              // Nút đến trang cuối cùng
              if (state.totalPages > 2)
                _buildPaginationButton(
                  icon: Icons.last_page,
                  onPressed:
                      state.currentPage < state.totalPages
                          ? () => petsCubit.goToPage(state.totalPages)
                          : null,
                  isActive: state.currentPage < state.totalPages,
                  tooltip: 'Trang cuối',
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget cho nút điều hướng phân trang
  Widget _buildPaginationButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isActive,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(50),
          child: Ink(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isActive
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.grey[200],
            ),
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: isActive ? AppColors.primary : Colors.grey,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Phương thức tạo và hiển thị thông báo ở phía trên màn hình
  void _showTopNotification({
    required BuildContext context,
    required String message,
    bool isSuccess = true,
  }) {
    // Xóa các thông báo cũ nếu có
    _removeCurrentNotification(context);

    // Tạo một OverlayEntry chứa thông báo
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).viewPadding.top + 10, // Hiển thị ngay dưới statusbar
        left: 10,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSuccess ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
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
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          message,
                          style: const TextStyle(color: Colors.white),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Thêm thông báo vào Overlay và lưu lại để có thể xóa sau
    _currentNotification = overlayEntry;
    Overlay.of(context).insert(overlayEntry);

    // Tự động ẩn thông báo sau 3 giây
    Future.delayed(const Duration(seconds: 3), () {
      _removeCurrentNotification(context);
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
    // Xác định các màu sắc dễ thương
    final Color tagColor = _getPastelColor(pet.species ?? 'Không rõ');


    // Sử dụng LayoutBuilder để responsive với kích thước có sẵn
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Lấy kích thước màn hình và kiểm tra hướng màn hình
          final mediaQuery = MediaQuery.of(context);
          final screenWidth = mediaQuery.size.width;
          final screenHeight = mediaQuery.size.height;
          final isLandscape = screenWidth > screenHeight;

          // Tính toán kích thước card responsive
          double calculatedCardWidth;

          if (screenWidth < 360) {
            // Màn hình rất nhỏ: 2 card mỗi hàng
            calculatedCardWidth = (screenWidth - 48) / 2;
          } else if (screenWidth < 600) {
            // Màn hình điện thoại thông thường: 3 card mỗi hàng
            calculatedCardWidth = (screenWidth - 64) / 3;
          } else {
            // Màn hình lớn: 4 card mỗi hàng
            calculatedCardWidth = (screenWidth - 96) / 4;
          }

          // Giới hạn kích thước tối đa và tối thiểu của card
          // Điều chỉnh kích thước dựa trên hướng màn hình
          final double maxCardWidth = isLandscape ? 200.0 : 250.0;
          final double cardWidth = calculatedCardWidth.clamp(80.0, maxCardWidth);

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            splashColor: tagColor.withOpacity(0.1),
            highlightColor: tagColor.withOpacity(0.05),
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
            child: SizedBox(
              width: cardWidth, // Sử dụng cardWidth để đặt kích thước
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Species tag and gender icon
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0
                    ),
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
                        // Species
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
                              pet.species ?? 'Không rõ',
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        // Gender icon
                        if (pet.gender != null)
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              pet.gender?.toLowerCase() == 'male'
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
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: tagColor.withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: 0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            image:
                                pet.image != null && pet.image!.isNotEmpty
                                    ? DecorationImage(
                                      image: NetworkImage(pet.image!),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                          ),
                          child:
                              pet.image == null || pet.image!.isEmpty
                                  ? ClipOval(
                                    child: _buildPlaceholderImage(tagColor),
                                  )
                                  : null,
                        ),

                        const SizedBox(width: 16.0),

                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
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

                              // Age
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.cake_rounded,
                                    size: 14.0,
                                    color: tagColor,
                                  ),
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

                              // Button
                              Row(
                                children: [
                                  // Chi tiết button
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
                                            petSpecies: pet.species ?? "Không rõ",
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: tagColor.withOpacity(0.9),
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

                                  // Delete button
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
                                      child: const Icon(
                                        Icons.delete_outline,
                                        size: 20.0,
                                      ),
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
            ),);
          },

      ),
    );
  }

  // Phương thức tạo placeholder cho avatar
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
          color: themeColor.withOpacity(0.5),
        ),
      ),
    );
  }

  // Màu pastel dựa vào loài
  Color _getPastelColor(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
      case 'chó':
        return Color(0xFF6FB3D6); // Xanh dương nhạt dễ thương
      case 'cat':
      case 'mèo':
        return Color(0xFF90C290); // Cam nhạt pastel
      default:
        return Color(0xFF8AABFF); // Xanh nhạt mặc định
    }
  }

  // Icon dễ thương cho từng loài
  IconData _getCuteSpeciesIcon(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
      case 'chó':
        return Icons.pets; // Icon chó dễ thương
      case 'cat':
      case 'mèo':
        return Icons.pets;
      default:
        return Icons.favorite;
    }
  }

  // Hiển thị hộp thoại xác nhận xóa thú cưng
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
              child: const Text('Xóa'),
              onPressed: () {
                // Sử dụng context gốc để truy cập DeletePetCubit
                context.read<DeletePetCubit>().deletePet(petId);

                // Đóng hộp thoại xác nhận
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Custom clipper để tạo góc cong cho hình ảnh
class PetImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Vẽ path với các góc cong
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 20);

    // Góc cong bên phải
    path.quadraticBezierTo(
      size.width - 10,
      size.height,
      size.width - 30,
      size.height,
    );

    // Đường cong ở giữa
    path.quadraticBezierTo(
      size.width / 2 + 20,
      size.height + 15,
      size.width / 2,
      size.height,
    );

    path.quadraticBezierTo(
      size.width / 2 - 20,
      size.height - 15,
      30,
      size.height,
    );

    // Góc cong bên trái
    path.quadraticBezierTo(10, size.height, 0, size.height - 20);

    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom painter for creating subtle patterns
class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw some decorative patterns
    const double spacing = 20.0;
    final double maxX = size.width;
    final double maxY = size.height;

    // Draw small circles
    for (double x = 0; x < maxX; x += spacing) {
      for (double y = 0; y < maxY; y += spacing) {
        if ((x + y) % 40 == 0) {
          canvas.drawCircle(Offset(x, y), 2, paint);
        }
      }
    }

    // Draw some curved lines
    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.5,
      size.width * 0.5,
      size.height * 0.3
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.1,
      size.width,
      size.height * 0.4
    );

    canvas.drawPath(path, paint);

    // Draw another curved line
    final path2 = Path();
    path2.moveTo(0, size.height * 0.7);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.9,
      size.width * 0.6,
      size.height * 0.6
    );
    path2.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.4,
      size.width,
      size.height * 0.7
    );

    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
