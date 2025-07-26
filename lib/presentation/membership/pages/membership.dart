import 'package:flutter/material.dart';
import 'package:vaxpet/common/widgets/app_bar/app_bar.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1); // Bắt đầu ở tab Bạc
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Hạng thành viên',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        backgroundColor: AppColors.primary,
        hideBack: false,
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header với thông tin điểm tích lũy
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.stars_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Điểm tích lũy của bạn',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1,250 điểm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Hạng Bạc • Còn 750 điểm để lên hạng Vàng',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tab Bar với 3 hạng thành viên
              Container(
                padding: const EdgeInsets.all(4), // Thêm padding để tạo khoảng cách
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), // Giảm border radius để phù hợp với padding
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(0), // Đảm bảo indicator không bị padding
                  labelColor: AppColors.textBlack,
                  unselectedLabelColor: AppColors.textGray,
                  dividerColor: Colors.transparent, // Ẩn divider mặc định
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.stars, color: Colors.brown, size: 20),
                          const SizedBox(width: 8),
                          Text('Đồng'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.stars, color: Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          Text('Bạc'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.stars, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          Text('Vàng'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tab Bar View với nội dung từng hạng
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMembershipTierContent(
                      title: 'Hạng Đồng',
                      points: '0 - 499 điểm',
                      color: Colors.brown,
                      benefits: [
                        'Tích điểm cơ bản khi sử dụng dịch vụ',
                        'Thông báo về các chương trình khuyến mãi',
                        'Hỗ trợ khách hàng cơ bản',
                      ],
                      isActive: false,
                    ),
                    _buildMembershipTierContent(
                      title: 'Hạng Bạc',
                      points: '500 - 1,999 điểm',
                      color: Colors.grey,
                      benefits: [
                        'Giảm giá 5% cho tất cả dịch vụ',
                        'Quà sinh nhật voucher 50K',
                        'Ưu tiên đặt lịch khám',
                        'Tư vấn trực tuyến miễn phí',
                        'Nhận thông báo ưu đãi sớm',
                      ],
                      isActive: true,
                    ),
                    _buildMembershipTierContent(
                      title: 'Hạng Vàng',
                      points: '2,000+ điểm',
                      color: Colors.amber,
                      benefits: [
                        'Giảm giá 10% cho tất cả dịch vụ',
                        'Quà sinh nhật voucher 100K',
                        'Ưu tiên cao nhất khi đặt lịch',
                        'Tư vấn chuyên gia miễn phí',
                        'Dịch vụ giao hàng miễn phí',
                        'Kiểm tra sức khỏe định kỳ miễn phí',
                        'Hỗ trợ khẩn cấp 24/7',
                      ],
                      isActive: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembershipTierContent({
    required String title,
    required String points,
    required Color color,
    required List<String> benefits,
    required bool isActive,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header thông tin hạng
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isActive) ...[
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'HIỆN TẠI',
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            points,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Quyền lợi thành viên',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),

          const SizedBox(height: 12),

          // Danh sách quyền lợi
          ...benefits.map((benefit) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    benefit,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textBlack,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
