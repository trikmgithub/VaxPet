import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../appointment_health_certificate_note_detail/pages/appointment_health_certificate_note_detail.dart';
import '../bloc/appointment_health_certificate_note_cubit.dart';
import '../bloc/appointment_health_certificate_note_state.dart';

class AppointmentHealthCertificateNote extends StatefulWidget {
  final int petId;

  const AppointmentHealthCertificateNote({super.key, required this.petId});

  @override
  State<AppointmentHealthCertificateNote> createState() =>
      _AppointmentHealthCertificateNoteState();
}

class _AppointmentHealthCertificateNoteState extends State<AppointmentHealthCertificateNote>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static const healthCertificateType = 3; // Service type for health certificate

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Fetch health certificate appointments when widget initializes
    context
        .read<AppointmentHealthCertificateNoteCubit>()
        .fetchAppointmentHealthCertificateNotes(widget.petId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      AppointmentHealthCertificateNoteCubit,
      AppointmentHealthCertificateNoteState
    >(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Theme.of(context).scaffoldBackgroundColor, Colors.white],
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.schedule, size: 18),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Chờ xác nhận',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, size: 18),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Đã xác nhận',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: Pending Appointments
                    _buildPendingAppointments(state),
                    // Tab 2: Confirmed Appointments
                    _buildConfirmedAppointments(state),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPendingAppointments(AppointmentHealthCertificateNoteState state) {
    if (state.status == AppointmentHealthCertificateNoteStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.status == AppointmentHealthCertificateNoteStatus.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text('Lỗi: ${state.errorMessage}', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context
                  .read<AppointmentHealthCertificateNoteCubit>()
                  .fetchAppointmentHealthCertificateNotes(widget.petId),
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      );
    } else if (state.pendingAppointments == null) {
      return const Center(child: Text('Không có dữ liệu'));
    } else {
      return state.pendingAppointments!.fold(
        (failure) => Center(child: Text('Lỗi khi tải dữ liệu: $failure')),
        (pendingAppointments) {
          // Filter to only include appointments with serviceType == 3
          final filteredAppointments = pendingAppointments
              .where((appointment) =>
                  appointment['serviceType'] == healthCertificateType)
              .toList();

          if (filteredAppointments.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pending, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Không có lịch hẹn cấp giấy chứng nhận\nsức khỏe đang chờ xác nhận',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => await context
                .read<AppointmentHealthCertificateNoteCubit>()
                .refreshAppointments(widget.petId),
            child: ListView.builder(
              itemCount: filteredAppointments.length,
              itemBuilder: (context, index) {
                final appointment = filteredAppointments[index];
                return HealthCertificateAppointmentCard(
                  appointment: appointment,
                  isPending: true,
                );
              },
            ),
          );
        },
      );
    }
  }

  Widget _buildConfirmedAppointments(AppointmentHealthCertificateNoteState state) {
    if (state.status == AppointmentHealthCertificateNoteStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.status == AppointmentHealthCertificateNoteStatus.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text('Lỗi: ${state.errorMessage}', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context
                  .read<AppointmentHealthCertificateNoteCubit>()
                  .fetchAppointmentHealthCertificateNotes(widget.petId),
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      );
    } else if (state.confirmedAppointments == null) {
      return const Center(child: Text('Không có dữ liệu'));
    } else {
      // Sử dụng filteredAppointments từ state
      final filteredAppointments = state.filteredAppointments;

      if (filteredAppointments.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                state.selectedStatusFilter != null
                    ? 'Không có lịch hẹn với trạng thái đã chọn'
                    : 'Không có lịch hẹn cấp giấy chứng nhận\nsức khỏe đã xác nhận',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              if (state.selectedStatusFilter != null) ...[
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context
                      .read<AppointmentHealthCertificateNoteCubit>()
                      .clearStatusFilter(),
                  icon: Icon(Icons.clear),
                  label: Text('Xóa bộ lọc'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        );
      }

      return Column(
        children: [
          // Filter Header with Filter Icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tổng: ${filteredAppointments.length} lịch hẹn',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (state.selectedStatusFilter != null) ...[
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.filter_list,
                                size: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(width: 4),
                              Text(
                                _getStatusName(state.selectedStatusFilter!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => context
                                    .read<AppointmentHealthCertificateNoteCubit>()
                                    .clearStatusFilter(),
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () => _showFilterDialog(context, state),
                    icon: Icon(
                      Icons.filter_list,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    tooltip: 'Lọc theo trạng thái',
                    iconSize: 20,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => await context
                  .read<AppointmentHealthCertificateNoteCubit>()
                  .refreshAppointments(widget.petId),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: filteredAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = filteredAppointments[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    curve: Curves.easeOutCubic,
                    child: HealthCertificateAppointmentCard(
                      appointment: appointment,
                      isPending: false,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    }
  }

  // Helper method to get status name
  String _getStatusName(int status) {
    final statusMap = {
      2: 'Đã xác nhận',
      3: 'Đã đến',
      4: 'Đã xử lý',
      5: 'Đã thanh toán',
      9: 'Đã hoàn thành',
      10: 'Đã hủy',
      11: 'Đã từ chối',
    };
    return statusMap[status] ?? 'Không xác định';
  }

  void _showFilterDialog(
    BuildContext context,
    AppointmentHealthCertificateNoteState state,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    // Lấy cubit instance trước khi mở dialog
    final cubit = context.read<AppointmentHealthCertificateNoteCubit>();

    // Map appointment statuses to readable text for health certificate
    final statusMap = {
      2: {
        'name': 'Đã xác nhận',
        'color': Colors.blue,
        'icon': Icons.check_circle,
      },
      3: {
        'name': 'Đã đến',
        'color': Colors.purple,
        'icon': Icons.login,
      },
      4: {
        'name': 'Đã xử lý',
        'color': Colors.pinkAccent,
        'icon': Icons.hourglass_empty,
      },
      5: {
        'name': 'Đã thanh toán',
        'color': Colors.teal,
        'icon': Icons.payment,
      },
      9: {
        'name': 'Đã hoàn thành',
        'color': Colors.green,
        'icon': Icons.check_circle_outline,
      },
      10: {
        'name': 'Đã hủy',
        'color': Colors.red,
        'icon': Icons.cancel,
      },
      11: {
        'name': 'Đã từ chối',
        'color': Colors.grey,
        'icon': Icons.block,
      },
    };

    // Sử dụng appointmentsByStatus từ state để đếm appointments
    final statusCounts = <int, int>{};
    int totalHealthCertificateAppointments = 0;

    for (int status in state.availableStatuses) {
      final count = state.getCountForStatus(status);
      if (count > 0) {
        statusCounts[status] = count;
        totalHealthCertificateAppointments += count;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: isTablet ? screenWidth * 0.5 : null,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(dialogContext).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.grey.shade50],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(isTablet ? 24 : 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: isTablet ? 24 : 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Lọc theo trạng thái',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 20 : 18,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[600],
                          size: isTablet ? 24 : 20,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isTablet ? 24 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // All option
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: state.selectedStatusFilter == null
                                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: state.selectedStatusFilter == null
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade200,
                              width: state.selectedStatusFilter == null ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.all_inclusive,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              'Tất cả',
                              style: TextStyle(
                                fontWeight: state.selectedStatusFilter == null
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                fontSize: isTablet ? 16 : 14,
                              ),
                            ),
                            subtitle: Text(
                              '$totalHealthCertificateAppointments lịch hẹn',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: isTablet ? 14 : 12,
                              ),
                            ),
                            trailing: state.selectedStatusFilter == null
                                ? Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context).primaryColor,
                                    size: 20,
                                  )
                                : null,
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                              cubit.clearStatusFilter();
                            },
                          ),
                        ),

                        // Status filter options
                        ...state.availableStatuses.map((status) {
                          final count = state.getCountForStatus(status);
                          final statusInfo = statusMap[status];

                          if (statusInfo == null || count == 0) {
                            return const SizedBox.shrink();
                          }

                          final isSelected = state.selectedStatusFilter == status;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (statusInfo['color'] as Color).withValues(alpha: 0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? (statusInfo['color'] as Color)
                                    : Colors.grey.shade200,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (statusInfo['color'] as Color).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  statusInfo['icon'] as IconData,
                                  color: statusInfo['color'] as Color,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                statusInfo['name'] as String,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  fontSize: isTablet ? 16 : 14,
                                ),
                              ),
                              subtitle: Text(
                                '$count lịch hẹn',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: isTablet ? 14 : 12,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (statusInfo['color'] as Color).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '$count',
                                      style: TextStyle(
                                        color: statusInfo['color'] as Color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.check_circle,
                                      color: statusInfo['color'] as Color,
                                      size: 20,
                                    ),
                                  ],
                                ],
                              ),
                              onTap: () {
                                Navigator.of(dialogContext).pop();
                                cubit.setStatusFilter(status);
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                // Footer
                Container(
                  padding: EdgeInsets.all(isTablet ? 24 : 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (state.selectedStatusFilter != null)
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            cubit.clearStatusFilter();
                          },
                          icon: Icon(
                            Icons.clear,
                            size: isTablet ? 20 : 18,
                            color: Colors.red,
                          ),
                          label: Text(
                            'Xóa bộ lọc',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: isTablet ? 16 : 14,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade400,
                              Colors.grey.shade500,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 32 : 24,
                              vertical: isTablet ? 16 : 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.close, size: isTablet ? 20 : 18),
                              const SizedBox(width: 8),
                              Text(
                                'Đóng',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: isTablet ? 16 : 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HealthCertificateAppointmentCard extends StatelessWidget {
  final dynamic appointment;
  final bool isPending;

  const HealthCertificateAppointmentCard({
    super.key,
    required this.appointment,
    required this.isPending,
  });

  // Helper method to get status info for health certificate
  Map<String, dynamic> _getStatusInfo(int status) {
    final statusMap = {
      1: {
        'name': 'Chờ xác nhận',
        'color': Colors.orange,
        'icon': Icons.schedule,
      },
      2: {
        'name': 'Đã xác nhận',
        'color': Colors.blue,
        'icon': Icons.check_circle,
      },
      3: {
        'name': 'Đã đến',
        'color': Colors.purple,
        'icon': Icons.login,
      },
      4: {
        'name': 'Đã xử lý',
        'color': Colors.pinkAccent,
        'icon': Icons.hourglass_empty,
      },
      5: {
        'name': 'Đã thanh toán',
        'color': Colors.teal,
        'icon': Icons.payment,
      },
      9: {
        'name': 'Đã hoàn thành',
        'color': Colors.green,
        'icon': Icons.check_circle_outline,
      },
      10: {
        'name': 'Đã hủy',
        'color': Colors.red,
        'icon': Icons.cancel,
      },
      11: {
        'name': 'Đã từ chối',
        'color': Colors.grey,
        'icon': Icons.block,
      },
    };

    return statusMap[status] ??
        {
          'name': 'Không xác định',
          'color': Colors.grey,
          'icon': Icons.help_outline,
        };
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    // Get the actual appointment status
    final appointmentStatus = appointment?['appointmentStatus'] ??
        appointment?['appointment']?['appointmentStatus'] ?? 0;
    final statusInfo = _getStatusInfo(appointmentStatus);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mã lịch hẹn',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment?['appointment']?['appointmentCode'] ??
                            appointment?['appointmentDetailCode'] ??
                            'Không có mã',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 18 : 16,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (statusInfo['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusInfo['color'] as Color,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusInfo['icon'] as IconData,
                        size: 16,
                        color: statusInfo['color'] as Color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        statusInfo['name'] as String,
                        style: TextStyle(
                          color: statusInfo['color'] as Color,
                          fontSize: isTablet ? 13 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Date and Time Row
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ngày hẹn',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isTablet ? 13 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _formatDate(appointment['appointmentDate']),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: isTablet ? 16 : 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.access_time,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thời gian',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isTablet ? 13 : 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatTime(appointment['appointmentDate']),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: isTablet ? 16 : 14,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Pet Information
            _buildInfoRow(
              context,
              Icons.pets,
              'Tên thú cưng',
              appointment?['appointment']?['petResponseDTO']?['name'] ??
                  'Không xác định',
              isTablet,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.category,
              'Loài',
              _getSpeciesText(
                appointment?['appointment']?['petResponseDTO']?['species'] ??
                    '',
              ),
              isTablet,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.verified,
              'Dịch vụ',
              _getServiceTypeText(appointment?['serviceType'] ?? 0),
              isTablet,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.location_on,
              'Địa điểm',
              _getLocationText(appointment?['appointment']?['location'] ?? 0),
              isTablet,
            ),

            const SizedBox(height: 20),

            // Action Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to detail page for both pending and confirmed appointments
                      // Add null safety check for appointmentDetailId
                      final appointmentId = appointment['appointmentId'];
                      if (appointmentId != null) {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                AppointmentHealthCertificateNoteDetailPage(
                                  appointmentId: appointmentId,
                                ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: animation.drive(
                                  Tween(
                                    begin: const Offset(1.0, 0.0),
                                    end: Offset.zero,
                                  ).chain(CurveTween(curve: Curves.easeOutCubic)),
                                ),
                                child: child,
                              );
                            },
                          ),
                        );
                      } else {
                        // Show error message if appointmentDetailId is null
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Có lỗi xảy ra khi tải thông tin lịch hẹn'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 24 : 20,
                        vertical: isTablet ? 14 : 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(Icons.visibility, size: isTablet ? 20 : 18),
                    label: Text(
                      'Xem chi tiết',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isTablet,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: isTablet ? 18 : 16,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: isTablet ? 13 : 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet ? 15 : 14,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Không xác định';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return 'Không xác định';
    }
  }

  String _formatTime(String? timeString) {
    if (timeString == null) return 'Không xác định';
    try {
      final dateTime = DateTime.parse(timeString);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return 'Không xác định';
    }
  }

  String _getSpeciesText(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
        return 'Chó';
      case 'cat':
        return 'Mèo';
      default:
        return species.isNotEmpty ? species : 'Không xác định';
    }
  }

  String _getServiceTypeText(int serviceType) {
    switch (serviceType) {
      case 3:
        return 'Cấp giấy chứng nhận sức khỏe';
      case 1:
        return 'Tiêm chủng';
      case 2:
        return 'Cấy chip';
      default:
        return 'Dịch vụ khác';
    }
  }

  String _getLocationText(int location) {
    switch (location) {
      case 1:
        return 'Trung tâm';
      case 2:
        return 'Tại nhà';
      default:
        return 'Không xác định';
    }
  }

  void _showAppointmentDetails(BuildContext context, dynamic appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chi tiết lịch hẹn'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Mã: ${appointment?['appointment']?['appointmentCode'] ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Khách hàng: ${appointment?['appointment']?['customerResponseDTO']?['fullName'] ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Thú cưng: ${appointment?['appointment']?['petResponseDTO']?['name'] ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Địa chỉ: ${appointment?['appointment']?['address'] ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Ngày hẹn: ${_formatDate(appointment['appointmentDate'])} ${_formatTime(appointment['appointmentDate'])}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}
