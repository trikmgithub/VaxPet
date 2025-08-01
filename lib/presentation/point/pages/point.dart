import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/presentation/preferential/bloc/preferential_state.dart';

import '../../../common/widgets/app_bar/app_bar.dart';
import '../bloc/all_voucher_cubit.dart';
import '../bloc/customer_voucher_cubit.dart';
import '../widgets/all_voucher.dart';
import '../widgets/customer_voucher.dart';

class PointPage extends StatefulWidget {
  final CustomerRankingInfo customerRankingInfo;

  const PointPage({
    super.key,
    required this.customerRankingInfo,
  });

  @override
  State<PointPage> createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          'Đổi điểm',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        backgroundColor: AppColors.primary,
        hideBack: false,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Header với thông tin điểm tích lũy
          Container(
            margin: EdgeInsets.all(16),
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
                  '${widget.customerRankingInfo.currentPoints.toString().replaceAllMapped(
                    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                    (Match m) => '${m[1]},',
                  )} điểm',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.customerRankingInfo.nextRank.isNotEmpty
                      ? '${widget.customerRankingInfo.currentRankDisplayName} • Còn ${widget.customerRankingInfo.pointsToNextRank.toString().replaceAllMapped(
                          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        )} điểm để lên ${widget.customerRankingInfo.nextRankDisplayName}'
                      : widget.customerRankingInfo.currentRankDisplayName,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Tab bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              tabs: [
                Tab(
                  text: 'Khám phá',
                ),
                Tab(
                  text: 'Đã đổi',
                ),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Khám phá tab - All Vouchers
                BlocProvider(
                  create: (context) => AllVoucherCubit(),
                  child: AllVoucher(
                    currentPoints: widget.customerRankingInfo.currentPoints,
                    customerId: widget.customerRankingInfo.customerId,
                  ),
                ),
                // Đã đổi tab - Customer Vouchers
                BlocProvider(
                  create: (context) => CustomerVoucherCubit(),
                  child: const CustomerVoucher(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
