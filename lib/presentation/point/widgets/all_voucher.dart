import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';

import '../bloc/all_voucher_cubit.dart';
import '../bloc/all_voucher_state.dart';

class AllVoucher extends StatefulWidget {
  const AllVoucher({super.key});

  @override
  State<AllVoucher> createState() => _AllVoucherState();
}

class _AllVoucherState extends State<AllVoucher> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial vouchers
    context.read<AllVoucherCubit>().getAllVouchers();
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

  void _onStatusFilter(bool? status) {
    setState(() {
      _selectedStatus = status;
    });
    context.read<AllVoucherCubit>().filterByStatus(status);
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
              const SizedBox(height: 12),
              // Filter Chips
              Row(
                children: [
                  Text(
                    'Trạng thái: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            label: const Text('Tất cả'),
                            selected: _selectedStatus == null,
                            onSelected: (_) => _onStatusFilter(null),
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            checkmarkColor: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            label: const Text('Còn hạn'),
                            selected: _selectedStatus == true,
                            onSelected: (_) => _onStatusFilter(true),
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            checkmarkColor: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            label: const Text('Hết hạn'),
                            selected: _selectedStatus == false,
                            onSelected: (_) => _onStatusFilter(false),
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            checkmarkColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
            color: Colors.grey.withOpacity(0.1),
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
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
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
    final String title = voucher['title'] ?? voucher['name'] ?? 'Voucher';
    final int points = voucher['points'] ?? voucher['requiredPoints'] ?? 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận đổi voucher'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bạn có muốn đổi voucher "$title" với $points điểm?'),
              const SizedBox(height: 8),
              Text(
                'Điểm hiện tại: 1,250 điểm',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement exchange logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đổi voucher thành công!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Đồng ý'),
            ),
          ],
        );
      },
    );
  }
}
