import 'package:flutter/material.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';

import '../widgets/future_appointment_tab.dart';
import '../widgets/past_appointment_tab.dart';
import '../widgets/today_appointment_tab.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final primaryColor = AppColors.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // AppBar tùy chỉnh với phần dưới cùng bo tròn
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Text(
                  'Lịch hẹn',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width > 600 ? 24 : 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Phần TabBar tách riêng khỏi AppBar
          Container(
            color: Colors.white, // Màu nền giống với body
            child: TabBar(
              controller: _tabController,
              labelColor: primaryColor, // Màu chữ khi tab được chọn
              unselectedLabelColor: Colors.grey, // Màu chữ khi tab không được chọn
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: primaryColor, // Màu gạch chân
              dividerColor: Colors.transparent,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenSize.width > 600 ? 16 : 14,
              ),
              tabs: const [
                Tab(
                  text: 'Hôm nay',
                  icon: Icon(Icons.today),
                ),
                Tab(
                  text: 'Tương lai',
                  icon: Icon(Icons.calendar_month),
                ),
                Tab(
                  text: 'Quá khứ',
                  icon: Icon(Icons.history),
                ),
              ],
            ),
          ),

          // Đường kẻ mỏng ngăn cách TabBar và nội dung
          Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.2)),

          // Phần nội dung
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // First tab - Hôm nay
                CalendarTabContainer(
                  child: TodayAppointmentTab(),
                ),

                // Second tab - Tương lai
                CalendarTabContainer(
                  child: FutureAppointmentTab(),
                ),

                // Third tab - Quá kh��
                CalendarTabContainer(
                  child: PastAppointmentTab(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget bọc mỗi tab để thêm padding và hiệu ứng
class CalendarTabContainer extends StatelessWidget {
  final Widget child;

  const CalendarTabContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.04,
        vertical: screenSize.height * 0.02,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    );
  }
}
