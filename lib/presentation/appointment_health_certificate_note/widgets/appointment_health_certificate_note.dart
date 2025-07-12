import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
  static const healthCertificateType = 2; // Service type for health certificate (changed from 3 to 2)

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
      return Center(child: Text('Lỗi: ${state.errorMessage}'));
    } else if (state.pendingAppointments == null) {
      return const Center(child: Text('Không có dữ liệu'));
    } else {
      return state.pendingAppointments!.fold(
        (failure) => Center(child: Text('Lỗi khi tải dữ liệu')),
        (pendingAppointments) {
          // Filter to only include appointments with serviceType == 3
          final filteredAppointments =
              pendingAppointments
                  .where(
                    (appointment) =>
                        appointment['serviceType'] == healthCertificateType,
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
                    'Không có lịch hẹn cấp giấy chứng nhận\nsức khỏe đang chờ xác nhận',
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
              onPressed:
                  () => context
                      .read<AppointmentHealthCertificateNoteCubit>()
                      .fetchAppointmentHealthCertificateNotes(widget.petId),
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
      return state.confirmedAppointments!.fold(
        (failure) => Center(child: Text('Lỗi khi tải dữ li��u')),
        (confirmedAppointments) {
          // Get filtered appointments based on selected status
          List<dynamic> filteredAppointments;
          if (state.selectedStatusFilter != null) {
            filteredAppointments = state.appointmentsByStatus[state.selectedStatusFilter!] ?? [];
          } else {
            filteredAppointments = confirmedAppointments;
          }

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
                      onPressed:
                          () =>
                              context
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
                                                  AppointmentHealthCertificateNoteCubit
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
        },
      );
    }
  }

  Widget _buildStatusFilter(
    AppointmentHealthCertificateNoteState state,
    BuildContext context,
  ) {
    // Get total count from confirmed appointments
    int totalCount = 0;
    state.confirmedAppointments?.fold(
      (failure) => 0,
      (appointments) => totalCount = appointments.length,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // All appointments option
            FilterChip(
              label: Text('Tất cả ($totalCount)'),
              selected: state.selectedStatusFilter == null,
              onSelected: (selected) {
                if (selected) {
                  context
                      .read<AppointmentHealthCertificateNoteCubit>()
                      .clearStatusFilter();
                }
              },
              selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            // Status-specific options
            ...state.availableStatuses.map((status) {
              final count = state.appointmentsByStatus[status]?.length ?? 0;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text('${_getStatusName(status)} ($count)'),
                  selected: state.selectedStatusFilter == status,
                  onSelected: (selected) {
                    if (selected) {
                      context
                          .read<AppointmentHealthCertificateNoteCubit>()
                          .setStatusFilter(status);
                    } else {
                      context
                          .read<AppointmentHealthCertificateNoteCubit>()
                          .clearStatusFilter();
                    }
                  },
                  selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  checkmarkColor: Theme.of(context).primaryColor,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilteredAppointmentsList(AppointmentHealthCertificateNoteState state) {
    List<dynamic> appointmentsToShow;

    if (state.selectedStatusFilter != null) {
      // Show appointments for selected status
      appointmentsToShow = state.appointmentsByStatus[state.selectedStatusFilter!] ?? [];
    } else {
      // Show all confirmed appointments
      appointmentsToShow = state.confirmedAppointments?.fold(
        (failure) => <dynamic>[],
        (appointments) => appointments,
      ) ?? [];
    }

    if (appointmentsToShow.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_list_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Không có lịch hẹn nào\ncho bộ lọc này',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: appointmentsToShow.length,
      itemBuilder: (context, index) {
        final appointment = appointmentsToShow[index];
        return HealthCertificateAppointmentCard(
          appointment: appointment,
          isPending: false,
        );
      },
    );
  }

  String _getStatusName(int status) {
    switch (status) {
      case 2:
        return 'Đã xác nhận';
      case 3:
        return 'Đã check-in';
      case 4:
        return 'Đã khám';
      case 5:
        return 'Đã cấp';
      case 6:
        return 'ABC 6';
      case 7:
        return 'ABC 7';
      case 8:
        return 'ABC 8';
      case 9:
        return 'Đã thanh toán';
      case 10:
        return 'Hoàn thành';
      case 11:
        return 'Đã hủy';
      default:
        return 'Trạng thái $status';
    }
  }

  void _showFilterDialog(
    BuildContext context,
    AppointmentHealthCertificateNoteState state,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    // Get cubit instance before opening dialog
    final cubit = context.read<AppointmentHealthCertificateNoteCubit>();

    // Map appointment statuses to readable text for health certificate
    final statusMap = {
      2: {
        'name': 'Đã xác nhận',
        'color': Colors.blue,
        'icon': Icons.check_circle,
      },
      3: {
        'name': 'Đã check-in',
        'color': Colors.orange,
        'icon': Icons.login,
      },
      4: {
        'name': 'Đã khám',
        'color': Colors.purple,
        'icon': Icons.medical_services,
      },
      5: {
        'name': 'Đã cấp',
        'color': Colors.green,
        'icon': Icons.verified,
      },
      6: {
        'name': 'ABC 6',
        'color': Colors.green,
        'icon': Icons.check,
      },
      7: {
        'name': 'ABC 7',
        'color': Colors.green,
        'icon': Icons.check,
      },
      8: {
        'name': 'ABC 8',
        'color': Colors.green,
        'icon': Icons.check,
      },
      9: {
        'name': 'Đã thanh toán',
        'color': Colors.teal,
        'icon': Icons.payment,
      },
      10: {
        'name': 'Hoàn thành',
        'color': Colors.lightGreen,
        'icon': Icons.done_all,
      },
      11: {
        'name': 'Đã hủy',
        'color': Colors.red,
        'icon': Icons.cancel,
      },
    };

    // Calculate status counts
    final statusCounts = <int, int>{};
    int totalAppointments = 0;

    for (int status in state.availableStatuses) {
      final count = state.appointmentsByStatus[status]?.length ?? 0;
      if (count > 0) {
        statusCounts[status] = count;
        totalAppointments += count;
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
                              '$totalAppointments lịch hẹn',
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
                              cubit.clearStatusFilter();
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                        ),

                        // Status options
                        ...statusCounts.entries.map((entry) {
                          final status = entry.key;
                          final count = entry.value;
                          final statusInfo = statusMap[status]!;
                          final isSelected = state.selectedStatusFilter == status;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
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
                              trailing: isSelected
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
                      Text(
                        'Tổng cộng: $totalAppointments lịch hẹn',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          cubit.clearStatusFilter();
                          Navigator.of(dialogContext).pop();
                        },
                        icon: const Icon(Icons.clear_all, size: 16),
                        label: const Text('Xóa bộ lọc'),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
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
  final Map<String, dynamic> appointment;
  final bool isPending;

  const HealthCertificateAppointmentCard({
    super.key,
    required this.appointment,
    required this.isPending,
  });

  @override
  Widget build(BuildContext context) {
    final appointmentDate = DateTime.tryParse(
      appointment['appointmentDate']?.toString() ?? '',
    );
    final formattedDate = appointmentDate != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(appointmentDate)
        : 'Không xác định';

    final status = appointment['appointment']?['appointmentStatus'] ?? 0;
    final appointmentCode = appointment['appointment']?['appointmentCode'] ?? 'N/A';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Navigate to detail page (you may need to create this page)
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => AppointmentHealthCertificateNoteDetailPage(
          //       appointmentId: appointment['appointment']?['appointmentId'],
          //     ),
          //   ),
          // );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.verified,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Giấy chứng nhận sức khỏe',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (!isPending)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(status),
                        style: TextStyle(
                          color: _getStatusColor(status),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    formattedDate,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.confirmation_number, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Mã: $appointmentCode',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 2:
        return Colors.blue;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.green;
      case 6:
        return Colors.green;
      case 7:
        return Colors.green;
      case 8:
        return Colors.green;
      case 9:
        return Colors.teal;
      case 10:
        return Colors.green;
      case 11:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 2:
        return 'Đã xác nhận';
      case 3:
        return 'Đã check-in';
      case 4:
        return 'Đã khám';
      case 5:
        return 'Đã cấp';
      case 6:
        return 'ABC 6';
      case 7:
        return 'ABC 7';
      case 8:
        return 'ABC 8';
      case 9:
        return 'Đã thanh toán';
      case 10:
        return 'Hoàn thành';
      case 11:
        return 'Đã hủy';
      default:
        return 'Trạng thái $status';
    }
  }
}
