import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/presentation/calendar/pages/calendar.dart';
import 'package:vaxpet/presentation/profile/pages/profile.dart';

import '../../../common/bloc/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import '../../../common/bloc/bottom_nav_bar/bottom_nav_bar_event.dart';
import '../../../common/bloc/bottom_nav_bar/bottom_nav_bar_state.dart';
import '../../home/pages/home.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách các trang theo tab
    final List<Widget> pages = [
      const HomePage(), // Tab 1: Trang hồ sơ thú cưng
      const CalendarPage(),   // Tab 2: Trang lịch sử tiêm chủng
      const ProfilePage()     // Tab 3: Trang tài khoản
    ];

    return BlocProvider(
      create: (_) => BottomNavBarBloc(),
      child: Scaffold(
        body: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
          builder: (context, state) {
            // Đơn giản hóa logic - state luôn là NavigationChanged từ khởi tạo
            final index = (state as NavigationChanged).index;
            return IndexedStack(
              index: index,
              children: pages,
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
          builder: (context, state) {
            // Đơn giản hóa logic - state luôn là NavigationChanged từ khởi tạo
            final currentIndex = (state as NavigationChanged).index;

            return BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                context.read<BottomNavBarBloc>().add(NavigateTo(index: index));
              },
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.pets),
                  label: 'Hồ sơ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Lịch khám',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Tài khoản',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
