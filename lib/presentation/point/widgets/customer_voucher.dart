import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';

import '../bloc/customer_voucher_cubit.dart';
import '../bloc/customer_voucher_state.dart';

class CustomerVoucher extends StatefulWidget {
  const CustomerVoucher({super.key});

  @override
  State<CustomerVoucher> createState() => _CustomerVoucherState();
}

class _CustomerVoucherState extends State<CustomerVoucher> {
  @override
  void initState() {
    super.initState();
    // Load customer vouchers when widget is initialized
    context.read<CustomerVoucherCubit>().getCustomerVouchers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerVoucherCubit, CustomerVoucherState>(
      builder: (context, state) {
        if (state is CustomerVoucherLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is CustomerVoucherFailure) {
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
                  state.errorMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CustomerVoucherCubit>().getCustomerVouchers();
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        if (state is CustomerVoucherLoaded) {
          if (state.customerVouchers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bạn chưa đổi voucher nào',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hãy khám phá các voucher có sẵn để đổi điểm!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CustomerVoucherCubit>().getCustomerVouchers();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.customerVouchers.length,
              itemBuilder: (context, index) {
                final voucher = state.customerVouchers[index];
                return _buildVoucherCard(voucher);
              },
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget _buildVoucherCard(dynamic customerVoucher) {
    final voucher = customerVoucher['voucher'];
    final status = customerVoucher['status'];

    // Determine status display with softer colors
    String statusText = 'Đã đổi';
    Color statusColor = Colors.blue[300]!;
    IconData statusIcon = Icons.check_circle;

    if (status == 3) {
      statusText = 'Hết hạn';
      statusColor = Colors.blueGrey[300]!;
      statusIcon = Icons.cancel;
    } else if (status == 1) {
      statusText = 'Còn hiệu lực';
      statusColor = Colors.green[300]!;
      statusIcon = Icons.check_circle;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              statusColor.withValues(alpha: 0.05),
              Colors.grey[50]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    statusIcon,
                    color: statusColor.withValues(alpha: 0.7),
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                voucher['voucherName'] ?? 'Voucher',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Mã: ${voucher['voucherCode'] ?? ''}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.indigo[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              if (voucher['description'] != null)
                Text(
                  voucher['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.stars_rounded,
                    color: Colors.amber[400],
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${voucher['pointsRequired'] ?? 0} điểm',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber[600],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange[200]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Giảm ${voucher['discountAmount'] ?? 0}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Đổi: ${_formatDate(customerVoucher['redeemedAt'])}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  if (customerVoucher['expirationDate'] != null) ...[
                    Icon(
                      Icons.schedule_outlined,
                      size: 14,
                      color: status == 3 ? Colors.red[400] : Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Hết hạn: ${_formatDate(customerVoucher['expirationDate'])}',
                      style: TextStyle(
                        fontSize: 12,
                        color: status == 3 ? Colors.red[400] : Colors.grey[600],
                        fontWeight: status == 3 ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
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
}
