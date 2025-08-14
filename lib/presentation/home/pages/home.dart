import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaxpet/common/bloc/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import 'package:vaxpet/common/bloc/bottom_nav_bar/bottom_nav_bar_event.dart';
import 'package:vaxpet/common/bloc/notification/notification_bloc.dart';
import 'package:vaxpet/common/bloc/notification/notification_state.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/presentation/home/widgets/pet_card.dart';
import 'package:vaxpet/presentation/home/widgets/notification_badge.dart';
import 'dart:ui';

import '../../pet/pages/create_pet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int? accountId;
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  String _searchQuery = '';
  String _selectedFilter = 'all'; // 'all', 'dog', 'cat'

  @override
  void initState() {
    super.initState();
    _loadAccountId();

    // Setup animation for the FAB
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    // Lắng nghe thay đổi trong ô tìm kiếm
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAccountId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getInt('accountId');
    setState(() {
      accountId = storedId;
      isLoading = false;
    });
  }

  void _showFilterMenu(BuildContext context, Offset buttonPosition) {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        buttonPosition.dx - 100, // Điều chỉnh vị trí x
        buttonPosition.dy + 10,   // Hiển thị ngay dưới button
        buttonPosition.dx + 100,
        buttonPosition.dy + 200,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'all',
          child: _buildFilterMenuItem('Tất cả', 'all', Icons.pets),
        ),
        PopupMenuItem<String>(
          value: 'dog',
          child: _buildFilterMenuItem('Chó', 'dog', Icons.pets),
        ),
        PopupMenuItem<String>(
          value: 'cat',
          child: _buildFilterMenuItem('Mèo', 'cat', Icons.pets),
        ),
      ],
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ).then((String? value) {
      if (value != null) {
        setState(() {
          _selectedFilter = value;
        });
      }
    });
  }

  Widget _buildFilterMenuItem(String label, String value, IconData icon) {
    bool isSelected = _selectedFilter == value;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textGray,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textBlack,
            ),
          ),
          const SizedBox(width: 8),
          if (isSelected)
            Icon(
              Icons.check,
              size: 16,
              color: AppColors.primary,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin về kích thước màn hình
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pets,
              color: Colors.white,
              size: isSmallScreen ? 24 : 28,
            ),
            const SizedBox(width: 8),
            Text(
              'Danh sách thú cưng',
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 22 : 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              int appointmentCount = 0;

              if (state is NotificationUpdated) {
                appointmentCount = state.appointmentCount;
              }

              return IconButton(
                icon: NotificationBadge(
                  count: appointmentCount,
                  child: const Icon(Icons.notifications_outlined, color: Colors.white),
                ),
                onPressed: () {
                  // Chuyển tab đến Calendar Page (index 1) thay vì push trang mới
                  context.read<BottomNavBarBloc>().add(NavigateTo(index: 1));
                },
                tooltip: 'Lịch hẹn',
              );
            },
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search and header section
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.04,
                        vertical: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Danh sách thú cưng',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 18 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              Builder(
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    onTap: () {
                                      final RenderBox renderBox = context.findRenderObject() as RenderBox;
                                      final position = renderBox.localToGlobal(Offset.zero);
                                      _showFilterMenu(context, Offset(
                                        position.dx - 50, // Căn menu về bên trái một chút
                                        position.dy + renderBox.size.height + 5, // Ngay dưới icon
                                      ));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: _selectedFilter != 'all'
                                            ? AppColors.primary.withValues(alpha: 0.8)
                                            : AppColors.primary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Icon(
                                        Icons.filter_list,
                                        color: _selectedFilter != 'all'
                                            ? Colors.white
                                            : AppColors.primary,
                                        size: isSmallScreen ? 20 : 24,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Search bar
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm thú cưng...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.textGray,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Pet list
                    Expanded(
                      child:
                          accountId != null
                              ? Pets(
                                accountId: accountId!,
                                isSmallScreen: isSmallScreen,
                                searchQuery: _searchQuery,
                                selectedFilter: _selectedFilter,
                              )
                              : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 48,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Không tìm thấy account ID',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.textGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                    ),
                  ],
                ),
              ),
      floatingActionButton: ScaleTransition(
        scale: _animation,
        child: Container(
          margin: const EdgeInsets.only(
            bottom: 20,
          ), // Tạo khoảng cách với đáy để tránh bị che bởi thanh pagination
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          child: FloatingActionButton(
            onPressed: () {
              AppNavigator.push(context, CreatePetPage());
            },
            backgroundColor: AppColors.primary,
            elevation: 0,
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: isSmallScreen ? 24 : 30,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
