import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/presentation/service_history/bloc/service_history_cubit.dart';
import 'package:vaxpet/presentation/service_history/bloc/service_history_state.dart';

import '../../../common/widgets/app_bar/app_bar.dart';

class ServiceHistoryPage extends StatefulWidget {
  const ServiceHistoryPage({super.key});

  @override
  State<ServiceHistoryPage> createState() => _ServiceHistoryPageState();
}

class _ServiceHistoryPageState extends State<ServiceHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceHistoryCubit()..getServiceHistory(),
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            'Lịch sử mua hàng',
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
          child: BlocBuilder<ServiceHistoryCubit, ServiceHistoryState>(
            builder: (context, state) {
              if (state is ServiceHistoryLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is ServiceHistoryError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Có lỗi xảy ra',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ServiceHistoryCubit>().getServiceHistory();
                        },
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                );
              }

              if (state is ServiceHistoryLoaded) {
                if (state.serviceHistories.isEmpty) {
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
                          'Chưa có lịch sử dịch vụ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ServiceHistoryCubit>().getServiceHistory();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.serviceHistories.length,
                    itemBuilder: (context, index) {
                      final serviceHistory = state.serviceHistories[index];
                      return _ServiceHistoryCard(serviceHistory: serviceHistory);
                    },
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class _ServiceHistoryCard extends StatelessWidget {
  final ServiceHistoryEntity serviceHistory;

  const _ServiceHistoryCard({required this.serviceHistory});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with service type and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getServiceTypeColor(serviceHistory.serviceType),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    serviceHistory.serviceTypeName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(serviceHistory.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(serviceHistory.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Pet and Customer Info
            if (serviceHistory.pet != null || serviceHistory.customer != null) ...[
              Row(
                children: [
                  // Pet avatar
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: serviceHistory.pet?.image != null
                        ? NetworkImage(serviceHistory.pet!.image!)
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: serviceHistory.pet?.image == null
                        ? Icon(Icons.pets, color: Colors.grey[600])
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serviceHistory.pet?.name ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${_getSpeciesText(serviceHistory.pet?.species)} - ${serviceHistory.pet?.breed ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Chủ: ${serviceHistory.customer?.fullName ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Service Details
            _buildDetailRow('Ngày dịch vụ:', _formatDate(serviceHistory.serviceDate)),
            _buildDetailRow('Phương thức thanh toán:', _getPaymentMethodText(serviceHistory.paymentMethod)),
            _buildDetailRow('Số tiền:', _formatCurrency(serviceHistory.amount)),
            _buildDetailRow('Mã lịch hẹn:', '#${serviceHistory.appointmentId ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getServiceTypeColor(int? serviceType) {
    switch (serviceType) {
      case 1: // Vắc xin
        return Colors.green;
      case 2: // Cấy microchip
        return Colors.blue;
      case 3: // Chứng nhận sức khỏe
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String? status) {
    if (status?.toLowerCase() == 'completed') {
      return Colors.green;
    } else if (status?.toLowerCase() == 'pending') {
      return Colors.orange;
    } else if (status?.toLowerCase() == 'cancelled') {
      return Colors.red;
    }
    return Colors.grey;
  }

  String _getStatusText(String? status) {
    if (status?.toLowerCase() == 'completed') {
      return 'Hoàn thành';
    } else if (status?.toLowerCase() == 'pending') {
      return 'Đang chờ';
    } else if (status?.toLowerCase() == 'cancelled') {
      return 'Đã hủy';
    }
    return status ?? 'N/A';
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatCurrency(double? amount) {
    if (amount == null) return 'N/A';
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(amount);
  }

  String _getSpeciesText(String? species) {
    if (species?.toLowerCase() == 'dog') {
      return 'Chó';
    } else if (species?.toLowerCase() == 'cat') {
      return 'Mèo';
    }
    return species ?? 'N/A';
  }

  String _getPaymentMethodText(String? paymentMethod) {
    if (paymentMethod?.toLowerCase() == 'cash') {
      return 'Tiền mặt';
    } else if (paymentMethod?.toLowerCase() == 'banktransfer') {
      return 'Chuyển khoản';
    }
    return paymentMethod ?? 'N/A';
  }
}
