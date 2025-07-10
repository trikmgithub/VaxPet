import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../appointment_vaccination_note_detail/pages/appointment_vaccination_note_detail.dart';
import '../bloc/appointment_microchip_note_cubit.dart';
import '../bloc/appointment_microchip_note_state.dart';

class AppointmentMicrochipNote extends StatefulWidget {
  final int petId;

  const AppointmentMicrochipNote({super.key, required this.petId});

  @override
  State<AppointmentMicrochipNote> createState() =>
      _AppointmentMicrochipNoteState();
}

class _AppointmentMicrochipNoteState extends State<AppointmentMicrochipNote>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static const microchipType = 2; // Service type for microchip

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Fetch microchip appointments when widget initializes
    context
        .read<AppointmentMicrochipNoteCubit>()
        .fetchAppointmentMicrochipNotes(widget.petId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      AppointmentMicrochipNoteCubit,
      AppointmentMicrochipNoteState
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

  Widget _buildPendingAppointments(AppointmentMicrochipNoteState state) {
    if (state.status == AppointmentMicrochipNoteStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.status == AppointmentMicrochipNoteStatus.failure) {
      return Center(child: Text('Lỗi: ${state.errorMessage}'));
    } else if (state.pendingAppointments == null) {
      return const Center(child: Text('Không có dữ liệu'));
    } else {
      return state.pendingAppointments!.fold(
        (failure) => Center(child: Text('Lỗi khi tải dữ liệu')),
        (pendingAppointments) {
          // Filter to only include appointments with serviceType == 2
          final filteredAppointments =
              pendingAppointments
                  .where(
                    (appointment) =>
                        appointment['serviceType'] == microchipType,
                  )
                  .toList();

          if (filteredAppointments.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pending, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Không có lịch hẹn cấy chip\nđang chờ xác nhận',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh:
                () async => await context
                    .read<AppointmentMicrochipNoteCubit>()
                    .refreshAppointments(widget.petId),
            child: ListView.builder(
              itemCount: filteredAppointments.length,
              itemBuilder: (context, index) {
                final appointment = filteredAppointments[index];
                return AppointmentCard(
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

  Widget _buildConfirmedAppointments(AppointmentMicrochipNoteState state) {
    if (state.status == AppointmentMicrochipNoteStatus.loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải dữ liệu...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    } else if (state.status == AppointmentMicrochipNoteStatus.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text('Lỗi: ${state.errorMessage}', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed:
                  () => context
                      .read<AppointmentMicrochipNoteCubit>()
                      .fetchAppointmentMicrochipNotes(widget.petId),
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      );
    } else if (state.confirmedAppointments == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Không có dữ liệu', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    } else {
      // Sử dụng filteredAppointments từ state
      final filteredAppointments = state.filteredAppointments;

      if (filteredAppointments.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.memory_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                state.selectedStatusFilter != null
                    ? 'Không có lịch hẹn với trạng thái đã chọn'
                    : 'Không có lịch hẹn cấy chip\nđã xác nhận',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              if (state.selectedStatusFilter != null) ...[
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed:
                      () =>
                          context
                              .read<AppointmentMicrochipNoteCubit>()
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
                            color: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.3),
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
                                onTap:
                                    () =>
                                        context
                                            .read<
                                              AppointmentMicrochipNoteCubit
                                            >()
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
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.1),
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
              onRefresh:
                  () async => await context
                      .read<AppointmentMicrochipNoteCubit>()
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
                    child: AppointmentCard(
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
      3: 'Đã check-in',
      4: 'Đã tiêm',
      5: 'Đã cấy chip',
      6: 'Đã thanh toán',
      7: 'Đã áp dụng',
      8: 'Hoàn thành',
      9: 'Completed',
      10: 'Đã hủy',
      11: 'Bị từ chối',
    };
    return statusMap[status] ?? 'Không xác định';
  }

  void _showFilterDialog(
    BuildContext context,
    AppointmentMicrochipNoteState state,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    // Lấy cubit instance trước khi mở dialog
    final cubit = context.read<AppointmentMicrochipNoteCubit>();

    // Map appointment statuses to readable text
    final statusMap = {
      2: {
        'name': 'Đã xác nhận',
        'color': Colors.green,
        'icon': Icons.check_circle,
      },
      3: {'name': 'Đã check-in', 'color': Colors.blue, 'icon': Icons.login},
      4: {
        'name': 'Đã tiêm',
        'color': Colors.purple,
        'icon': Icons.medical_services,
      },
      5: {'name': 'Đã cấy chip', 'color': Colors.indigo, 'icon': Icons.memory},
      6: {'name': 'Đã thanh toán', 'color': Colors.teal, 'icon': Icons.payment},
      7: {'name': 'Đã áp dụng', 'color': Colors.amber, 'icon': Icons.done_all},
      8: {'name': 'Hoàn thành', 'color': Colors.cyan, 'icon': Icons.task_alt},
      9: {
        'name': 'Completed',
        'color': Colors.lightGreen,
        'icon': Icons.verified,
      },
      10: {'name': 'Đã hủy', 'color': Colors.red, 'icon': Icons.cancel},
      11: {'name': 'Bị từ chối', 'color': Colors.grey, 'icon': Icons.block},
    };

    // Sử dụng appointmentsByStatus từ state để đếm appointments
    final statusCounts = <int, int>{};
    int totalMicrochipAppointments = 0;

    for (int status in state.availableStatuses) {
      final count = state.getCountForStatus(status);
      if (count > 0) {
        statusCounts[status] = count;
        totalMicrochipAppointments += count;
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
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.1),
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
                            color:
                                state.selectedStatusFilter == null
                                    ? Theme.of(
                                      context,
                                    ).primaryColor.withValues(alpha: 0.1)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  state.selectedStatusFilter == null
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
                                color: Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.1),
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
                                fontWeight:
                                    state.selectedStatusFilter == null
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                fontSize: isTablet ? 16 : 14,
                              ),
                            ),
                            subtitle: Text(
                              '$totalMicrochipAppointments lịch hẹn',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: isTablet ? 14 : 12,
                              ),
                            ),
                            trailing:
                                state.selectedStatusFilter == null
                                    ? Icon(
                                      Icons.check_circle,
                                      color: Theme.of(context).primaryColor,
                                      size: 20,
                                    )
                                    : null,
                            onTap: () {
                              cubit.clearStatusFilter();
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                        ),

                        // Status options
                        ...statusCounts.entries.map((entry) {
                          final status = entry.key;
                          final count = entry.value;
                          final statusInfo = statusMap[status];

                          if (statusInfo == null) return const SizedBox.shrink();

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color:
                                  state.selectedStatusFilter == status
                                      ? Theme.of(
                                        context,
                                      ).primaryColor.withValues(alpha: 0.1)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    state.selectedStatusFilter == status
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.shade200,
                                width:
                                    state.selectedStatusFilter == status ? 2 : 1,
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
                                  color: (statusInfo['color'] as Color)
                                      .withValues(alpha: 0.1),
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
                                  fontWeight:
                                      state.selectedStatusFilter == status
                                          ? FontWeight.bold
                                          : FontWeight.w600,
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
                              trailing:
                                  state.selectedStatusFilter == status
                                      ? Icon(
                                        Icons.check_circle,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      )
                                      : null,
                              onTap: () {
                                cubit.setStatusFilter(status);
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    ),
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

class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final bool isPending;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.isPending,
  });

  @override
  Widget build(BuildContext context) {
    final appointmentData = appointment['appointment'] ?? {};
    final petData = appointment['pet'] ?? {};
    final serviceData = appointment['service'] ?? {};

    final appointmentCode = appointmentData['appointmentCode'] ?? 'N/A';
    final appointmentDate = appointment['appointmentDate'] ?? '';
    final appointmentTime = appointment['appointmentTime'] ?? '';
    final appointmentStatus = appointmentData['appointmentStatus'] ?? 0;
    final notes = appointment['notes'] ?? '';
    final serviceName = serviceData['serviceName'] ?? 'Cấy chip';

    // Format date
    String formattedDate = '';
    if (appointmentDate.isNotEmpty) {
      try {
        final date = DateTime.parse(appointmentDate);
        formattedDate = DateFormat('dd/MM/yyyy').format(date);
      } catch (e) {
        formattedDate = appointmentDate;
      }
    }

    // Get status info
    final statusInfo = _getStatusInfo(appointmentStatus);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: statusInfo['color'].withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navigate to detail page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentVaccinationNoteDetailPage(
                appointmentId: appointmentData['appointmentId'] ?? 0,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with code and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      appointmentCode,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusInfo['color'].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusInfo['color'].withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          statusInfo['icon'],
                          size: 14,
                          color: statusInfo['color'],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          statusInfo['name'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusInfo['color'],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Service info
              Row(
                children: [
                  Icon(
                    Icons.memory,
                    size: 16,
                    color: Colors.indigo,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      serviceName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date and time
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    appointmentTime,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),

              // Notes (if available)
              if (notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.note,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          notes,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo(int status) {
    final statusMap = {
      1: {
        'name': 'Chờ xác nhận',
        'color': Colors.orange,
        'icon': Icons.schedule,
      },
      2: {
        'name': 'Đã xác nhận',
        'color': Colors.green,
        'icon': Icons.check_circle,
      },
      3: {
        'name': 'Đã check-in',
        'color': Colors.blue,
        'icon': Icons.login,
      },
      4: {
        'name': 'Đã tiêm',
        'color': Colors.purple,
        'icon': Icons.medical_services,
      },
      5: {
        'name': 'Đã cấy chip',
        'color': Colors.indigo,
        'icon': Icons.memory,
      },
      6: {
        'name': 'Đã thanh toán',
        'color': Colors.teal,
        'icon': Icons.payment,
      },
      7: {
        'name': 'Đã áp dụng',
        'color': Colors.amber,
        'icon': Icons.done_all,
      },
      8: {
        'name': 'Hoàn thành',
        'color': Colors.cyan,
        'icon': Icons.task_alt,
      },
      9: {
        'name': 'Completed',
        'color': Colors.lightGreen,
        'icon': Icons.verified,
      },
      10: {
        'name': 'Đã hủy',
        'color': Colors.red,
        'icon': Icons.cancel,
      },
      11: {
        'name': 'Bị từ chối',
        'color': Colors.grey,
        'icon': Icons.block,
      },
    };

    return statusMap[status] ?? {
      'name': 'Không xác định',
      'color': Colors.grey,
      'icon': Icons.help_outline,
    };
  }
}
