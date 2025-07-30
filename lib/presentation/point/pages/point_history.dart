import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/presentation/point/bloc/point_history_cubit.dart';
import 'package:vaxpet/presentation/point/bloc/point_history_state.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/app_bar/app_bar.dart';

class PointHistoryPage extends StatelessWidget {
  const PointHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PointHistoryCubit()..getPointHistory(),
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            'Lịch sử điểm',
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
          child: BlocBuilder<PointHistoryCubit, PointHistoryState>(
            builder: (context, state) {
              if (state is PointHistoryLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PointHistoryFailure) {
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
                        state.message,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<PointHistoryCubit>().getPointHistory();
                        },
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                );
              } else if (state is PointHistoryLoaded) {
                if (state.transactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Chưa có lịch sử giao dịch điểm',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<PointHistoryCubit>().getPointHistory();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = state.transactions[index];
                      return _buildTransactionCard(transaction);
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(PointTransaction transaction) {
    final isEarned = transaction.transactionType == 'Earned';
    final pointColor = isEarned ? Colors.green : Colors.red;
    final pointPrefix = isEarned ? '+' : '-';

    // Get service name or default title
    String title = 'Giao dịch điểm';
    if (transaction.payment != null) {
      title = transaction.payment!.serviceName;
    } else if (transaction.voucher != null) {
      title = 'Đổi voucher';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service name as title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Points information
            Row(
              children: [
                Icon(
                  isEarned ? Icons.add_circle_outline : Icons.remove_circle_outline,
                  size: 20,
                  color: pointColor,
                ),
                const SizedBox(width: 8),
                Text(
                  isEarned ? 'Tích điểm' : 'Đổi điểm',
                  style: TextStyle(
                    fontSize: 16,
                    color: pointColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '$pointPrefix${transaction.change} điểm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: pointColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              transaction.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),

            // Additional info (voucher if exists)
            if (transaction.voucher != null) ...[
              Row(
                children: [
                  const Icon(Icons.local_offer, size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    'Voucher: ${transaction.voucher!.voucherName}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Date and time
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _formatDate(transaction.transactionDate),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
