import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaxpet/common/widgets/app_bar/app_bar.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/presentation/membership/bloc/membership_cubit.dart';
import 'package:vaxpet/presentation/membership/bloc/membership_state.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late MembershipCubit _membershipCubit;

  @override
  void initState() {
    super.initState();
    _membershipCubit = MembershipCubit();
    _loadMembershipData();
  }

  void _loadMembershipData() async {
    try {
      print('Đang lấy customer ID từ SharedPreferences...');

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('customerId');

      if (customerId == null) {
        print('Không tìm thấy customerId trong SharedPreferences');
        _membershipCubit.emit(MembershipFailure(errorMessage: 'Không tìm thấy thông tin người dùng. Vui lòng đăng nhập lại.'));
        return;
      }

      print('Customer ID từ SharedPreferences: $customerId');
      _membershipCubit.getMembershipStatus(customerId);
    } catch (e) {
      print('Exception khi lấy customer ID: $e');
      _membershipCubit.emit(MembershipFailure(errorMessage: 'Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _membershipCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _membershipCubit,
      child: Scaffold(
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
          child: BlocConsumer<MembershipCubit, MembershipState>(
            listener: (context, state) {
              if (state is MembershipLoaded) {
                final memberships = state.membershipStatus.data.memberships;
                memberships.sort((a, b) => a.minPoints.compareTo(b.minPoints));

                // Khởi tạo TabController khi đã có dữ liệu
                if (_tabController == null) {
                  _tabController = TabController(
                    length: memberships.length,
                    vsync: this,
                    initialIndex: _getCurrentTabIndex(
                      state.membershipStatus.data.membershipRankingResponseDTO.currentRank,
                      memberships,
                    ),
                  );
                }
              }
            },
            builder: (context, state) {
              if (state is MembershipLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text('Đang tải thông tin membership...'),
                    ],
                  ),
                );
              }

              if (state is MembershipFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadMembershipData,
                        child: Text('Thử lại'),
                      ),
                    ],
                  ),
                );
              }

              if (state is MembershipLoaded && _tabController != null) {
                final membershipData = state.membershipStatus.data;
                final userRanking = membershipData.membershipRankingResponseDTO;
                final memberships = membershipData.memberships;

                // Sort memberships by minPoints to ensure correct order
                memberships.sort((a, b) => a.minPoints.compareTo(b.minPoints));

                return Padding(
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
                              '${userRanking.currentPoints} điểm',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Hạng ${_getRankDisplayName(userRanking.currentRank)} • Còn ${userRanking.pointsToNextRank} điểm để lên hạng ${_getRankDisplayName(userRanking.nextRank)}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Tab Bar với các hạng thành viên
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          controller: _tabController!,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
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
                          indicatorPadding: const EdgeInsets.all(0),
                          labelColor: AppColors.textBlack,
                          unselectedLabelColor: AppColors.textGray,
                          dividerColor: Colors.transparent,
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          tabs: memberships.map((membership) => Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.stars, color: _getRankColor(membership.rank), size: 20),
                                const SizedBox(width: 8),
                                Text(membership.name),
                              ],
                            ),
                          )).toList(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tab Bar View với nội dung từng hạng
                      Expanded(
                        child: TabBarView(
                          controller: _tabController!,
                          children: memberships.map((membership) => _buildMembershipTierContent(
                            membership: membership,
                            isActive: membership.rank == userRanking.currentRank,
                            userRanking: userRanking,
                          )).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Center(
                child: Text('Đang khởi tạo...'),
              );
            },
          ),
        ),
      ),
    );
  }

  String _getRankDisplayName(String rank) {
    switch (rank.toLowerCase()) {
      case 'bronze':
        return 'Đồng';
      case 'silver':
        return 'Bạc';
      case 'gold':
        return 'Vàng';
      default:
        return rank;
    }
  }

  Color _getRankColor(String rank) {
    switch (rank.toLowerCase()) {
      case 'bronze':
        return Colors.brown;
      case 'silver':
        return Colors.grey;
      case 'gold':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  int _getCurrentTabIndex(String currentRank, List<Membership> memberships) {
    for (int i = 0; i < memberships.length; i++) {
      if (memberships[i].rank.toLowerCase() == currentRank.toLowerCase()) {
        return i;
      }
    }
    return 0;
  }

  Widget _buildMembershipTierContent({
    required Membership membership,
    required bool isActive,
    required MembershipRankingResponse userRanking,
  }) {
    Color color = _getRankColor(membership.rank);
    String displayName = _getRankDisplayName(membership.rank);

    // Parse benefits from string to list
    List<String> benefits = membership.benefits.split('.').where((benefit) => benefit.trim().isNotEmpty).map((benefit) => benefit.trim()).toList();

    // Get points range for display
    String pointsRange;
    if (membership.rank.toLowerCase() == 'bronze') {
      pointsRange = '${membership.minPoints}+ điểm';
    } else if (membership.rank.toLowerCase() == 'silver') {
      pointsRange = '${membership.minPoints}+ điểm';
    } else {
      pointsRange = '${membership.minPoints}+ điểm';
    }

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
                                'Hạng $displayName',
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
                            pointsRange,
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
            'Mô tả',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
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
            child: Text(
              membership.description,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textBlack,
                height: 1.4,
              ),
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
          if (benefits.isNotEmpty) ...benefits.map((benefit) => Container(
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
          )).toList() else Container(
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
                    membership.benefits,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textBlack,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
