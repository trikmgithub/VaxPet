import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/all_voucher_cubit.dart';
import '../bloc/all_voucher_state.dart';
import '../bloc/post_voucher_cubit.dart';
import '../bloc/post_voucher_state.dart';

class AllVoucher extends StatefulWidget {
  final int? currentPoints;
  final int? customerId;

  const AllVoucher({
    super.key,
    this.currentPoints,
    this.customerId,
  });

  @override
  State<AllVoucher> createState() => _AllVoucherState();
}

class _AllVoucherState extends State<AllVoucher> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int? _selectedDiscountPercent; // Changed from bool? _selectedStatus
  int? _customerId;
  int? _currentPoints;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Use passed parameters or fallback to SharedPreferences
    _customerId = widget.customerId;
    _currentPoints = widget.currentPoints;

    // If no parameters passed, load from SharedPreferences
    if (_customerId == null || _currentPoints == null) {
      _loadCustomerData();
    }

    // Load initial vouchers
    context.read<AllVoucherCubit>().getAllVouchers();
  }

  Future<void> _loadCustomerData() async {
    final prefs = await SharedPreferences.getInstance();
    _customerId = prefs.getInt('customerId');
    _currentPoints = prefs.getInt('currentPoints');
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<AllVoucherCubit>().loadMoreVouchers();
    }
  }

  void _onSearch(String value) {
    context.read<AllVoucherCubit>().searchVouchers(value);
  }

  void _onDiscountPercentFilter(int? percent) { // Renamed from _onStatusFilter
    setState(() {
      _selectedDiscountPercent = percent;
    });
    context.read<AllVoucherCubit>().filterByDiscountPercent(percent); // Changed method call
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and Filter Section
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[50],
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm voucher...',
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              // const SizedBox(height: 12),
            ],
          ),
        ),
        // Vouchers List
        Expanded(
          child: BlocBuilder<AllVoucherCubit, AllVoucherState>(
            builder: (context, state) {
              if (state is AllVoucherLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AllVoucherError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Có lỗi xảy ra',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: TextStyle(color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AllVoucherCubit>().refreshVouchers();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                );
              } else if (state is AllVoucherLoaded) {
                if (state.vouchers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Không có voucher nào',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hiện tại chưa có voucher nào có sẵn',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<AllVoucherCubit>().refreshVouchers();
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.vouchers.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.vouchers.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final voucher = state.vouchers[index];
                      return _buildVoucherCard(voucher);
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVoucherCard(dynamic voucher) {
    // Extract voucher data safely with correct field names from API
    final String title = voucher['voucherName'] ?? 'Voucher';
    final String description = voucher['description'] ?? 'Mô tả voucher';
    final int points = voucher['pointsRequired'] ?? 0;
    final String? imageUrl = voucher['image'] ?? voucher['imageUrl'];
    final bool isActive = !voucher['isDeleted'] ?? true;
    final String? expiry = voucher['expirationDate'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top row with image and basic info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Voucher Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.card_giftcard,
                                size: 24,
                                color: Colors.grey[400],
                              );
                            },
                          )
                        : Icon(
                            Icons.card_giftcard,
                            size: 24,
                            color: Colors.grey[400],
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // Title and Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isActive ? 'Còn hạn' : 'Hết hạn',
                    style: TextStyle(
                      fontSize: 10,
                      color: isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Expiry date row (moved above points)
            if (expiry != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'HSD: ${_formatDate(expiry)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            // Bottom row with points and button
            Row(
              children: [
                // Points
                Icon(
                  Icons.stars,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  '$points điểm',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                // Exchange Button
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: isActive
                        ? () {
                            _showExchangeDialog(context, voucher);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    child: const Text('Đổi'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _showExchangeDialog(BuildContext context, dynamic voucher) {
    final String title = voucher['voucherName'] ?? 'Voucher';
    final int points = voucher['pointsRequired'] ?? 0;
    final int voucherId = voucher['voucherId'] ?? voucher['id'] ?? 0;

    // Check if user has enough points
    final bool hasEnoughPoints = _currentPoints != null && _currentPoints! >= points;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider(
          create: (context) => PostVoucherCubit(),
          child: BlocConsumer<PostVoucherCubit, PostVoucherState>(
            listener: (context, state) {
              if (state is PostVoucherSuccess) {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                // Refresh vouchers and reload customer data
                context.read<AllVoucherCubit>().refreshVouchers();
                _loadCustomerData();
              } else if (state is PostVoucherError) {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return AlertDialog(
                title: const Text('Xác nhận đổi voucher'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bạn có muốn đổi voucher "$title" với ${points.toString().replaceAllMapped(
                      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]},',
                    )} điểm?'),
                    const SizedBox(height: 8),
                    Text(
                      'Điểm hiện tại: ${_currentPoints?.toString().replaceAllMapped(
                        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},',
                      ) ?? '0'} điểm',
                      style: TextStyle(
                        color: hasEnoughPoints ? Colors.grey[600] : Colors.red,
                        fontSize: 14,
                        fontWeight: hasEnoughPoints ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    if (!hasEnoughPoints) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Bạn không đủ điểm để đổi voucher này!',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: state is PostVoucherLoading ? null : () => Navigator.of(dialogContext).pop(),
                    child: const Text('Hủy'),
                  ),
                  ElevatedButton(
                    onPressed: (state is PostVoucherLoading || !hasEnoughPoints || _customerId == null)
                        ? null
                        : () {
                            context.read<PostVoucherCubit>().exchangeVoucher(
                              customerId: _customerId!,
                              voucherId: voucherId,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: state is PostVoucherLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Đồng ý'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
