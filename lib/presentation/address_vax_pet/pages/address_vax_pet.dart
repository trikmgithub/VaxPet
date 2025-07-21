import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vaxpet/common/widgets/app_bar/app_bar.dart';
import 'package:vaxpet/core/constant/enviroment.dart';
import '../bloc/get_address_vax_pet_cubit.dart';
import '../bloc/get_address_vax_pet_state.dart';

class AddressVaxPetPage extends StatelessWidget {
  const AddressVaxPetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetAddressVaxPetCubit()..getAddressVaxPet(),
      child: const _AddressVaxPetContent(),
    );
  }
}

class _AddressVaxPetContent extends StatefulWidget {
  const _AddressVaxPetContent();

  @override
  State<_AddressVaxPetContent> createState() => _AddressVaxPetContentState();
}

class _AddressVaxPetContentState extends State<_AddressVaxPetContent> {
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  bool _mapLoading = true;

  // Chỉ lấy data từ API, không có default values
  double? latitude;
  double? longitude;
  String? clinicName;
  String? address;
  final String phone = '012 3456 7890'; // Số điện thoại giả định
  final String openingHours = '8:00 - 12:00 & 13:00-17:00 (Thứ 2 - Chủ nhật)';
  final String mapboxAccessToken = Environment.MAPBOX_KEY;

  @override
  void initState() {
    super.initState();
    MapboxOptions.setAccessToken(mapboxAccessToken);

    Timer(const Duration(seconds: 3), () {
      if (mounted && _mapLoading) {
        setState(() {
          _mapLoading = false;
        });
      }
    });
  }

  // Method cập nhật dữ liệu khi nhận được từ API
  void _updateAddressData(GetAddressVaxPetSuccess state) {
    setState(() {
      latitude = state.latitude;
      longitude = state.longitude;
      clinicName = state.clinicName;
      address = state.address;
    });

    // Update map nếu đã được tạo
    if (mapboxMap != null) {
      _updateMapLocation();
    }
  }

  // Method cập nhật vị trí map
  void _updateMapLocation() async {
    if (mapboxMap != null) {
      // Cập nhật camera position
      await mapboxMap!.easeTo(
        CameraOptions(
          center: Point(coordinates: Position(longitude!, latitude!)),
          zoom: 15.0,
        ),
        MapAnimationOptions(duration: 1000, startDelay: 0),
      );

      // Clear existing annotations và add mới
      await _addSimpleMarker();
    }
  }

  // Method kiểm tra trạng thái hoạt động
  Map<String, dynamic> _getClinicStatus() {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;
    final currentTime = currentHour * 60 + currentMinute;

    // Giờ làm việc: 8:00-12:00 và 13:00-17:00
    const morningStart = 8 * 60; // 8:00 = 480 phút
    const morningEnd = 12 * 60; // 12:00 = 720 phút
    const afternoonStart = 13 * 60; // 13:00 = 780 phút
    const afternoonEnd = 17 * 60; // 17:00 = 1020 phút

    if (currentTime >= morningStart && currentTime < morningEnd) {
      // Đang trong ca sáng (8:00 - 12:00)
      return {
        'status': 'Đang hoạt động',
        'color': Colors.green.shade700,
        'bgColor': Colors.green.shade50,
        'borderColor': Colors.green.shade200,
        'icon': Icons.access_time_rounded,
      };
    } else if (currentTime >= morningEnd && currentTime < afternoonStart) {
      // Nghỉ trưa (12:00 - 13:00)
      return {
        'status': 'Nghỉ trưa',
        'color': Colors.orange.shade700,
        'bgColor': Colors.orange.shade50,
        'borderColor': Colors.orange.shade200,
        'icon': Icons.lunch_dining_rounded,
      };
    } else if (currentTime >= afternoonStart && currentTime < afternoonEnd) {
      // Đang trong ca chiều (13:00 - 17:00)
      return {
        'status': 'Đang hoạt động',
        'color': Colors.green.shade700,
        'bgColor': Colors.green.shade50,
        'borderColor': Colors.green.shade200,
        'icon': Icons.access_time_rounded,
      };
    } else {
      // Đóng cửa (17:00 - 8:00 ngày hôm sau)
      return {
        'status': 'Ngoài giờ làm việc',
        'color': Colors.red.shade700,
        'bgColor': Colors.red.shade50,
        'borderColor': Colors.red.shade200,
        'icon': Icons.do_not_disturb_on_rounded,
      };
    }
  }

  // Method lấy thời gian mở cửa tiếp theo
  String _getNextOpenTime() {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;
    final currentTime = currentHour * 60 + currentMinute;

    const morningStart = 8 * 60; // 8:00
    const morningEnd = 12 * 60; // 12:00
    const afternoonStart = 13 * 60; // 13:00
    const afternoonEnd = 17 * 60; // 17:00

    if (currentTime < morningStart) {
      // Trước 8:00 sáng
      return 'Mở cửa lúc 8:00';
    } else if (currentTime >= morningEnd && currentTime < afternoonStart) {
      // Nghỉ trưa
      return 'Mở cửa lại lúc 13:00';
    } else if (currentTime >= afternoonEnd) {
      // Sau 17:00
      return 'Mở cửa lúc 8:00 ngày mai';
    } else {
      return 'Đang hoạt động';
    }
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    try {
      this.mapboxMap = mapboxMap;
      pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
      await _addSimpleMarker();
      setState(() {
        _mapLoading = false;
      });
    } catch (e) {
      setState(() {
        _mapLoading = false;
      });
    }
  }

  Future<void> _addSimpleMarker() async {
    if (pointAnnotationManager != null) {
      try {
        final pointAnnotationOptions = PointAnnotationOptions(
          geometry: Point(coordinates: Position(longitude!, latitude!)),
          // Thay emoji bằng text đơn giản
          textField: "VaxPet",
          textOffset: [0.0, -2.0],
          textColor: Colors.white.toARGB32(),
          textSize: 14.0,
          textHaloColor: AppColors.primary.toARGB32(),
          textHaloWidth: 3.0,
          // Thêm circle annotation để tạo marker đẹp hơn
        );
        await pointAnnotationManager!.create(pointAnnotationOptions);

        // Thêm circle marker để làm nổi bật vị trí
        final circleAnnotationManager = await mapboxMap!.annotations.createCircleAnnotationManager();
        final circleOptions = CircleAnnotationOptions(
          geometry: Point(coordinates: Position(longitude!, latitude!)),
          circleRadius: 8.0,
          circleColor: AppColors.primary.toARGB32(),
          circleStrokeColor: Colors.white.toARGB32(),
          circleStrokeWidth: 3.0,
        );
        await circleAnnotationManager.create(circleOptions);

      } catch (e) {
        print('Lỗi tạo marker: $e');
      }
    }
  }

  Future<void> _openMapsApp() async {
    // Hiển thị dialog xác nhận trước khi mở Google Maps
    final shouldOpenMaps = await _showOpenMapsConfirmation();
    if (!shouldOpenMaps) return;

    try {
      final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        _showMessage('Đã mở Google Maps');
      } else {
        _showMessage('Không thể mở Google Maps', isError: true);
      }
    } catch (e) {
      _showMessage('Lỗi khi mở bản đồ', isError: true);
    }
  }

  // Dialog xác nhận mở Google Maps
  Future<bool> _showOpenMapsConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isTablet = screenWidth > 600;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header với icon Maps
                Container(
                  padding: EdgeInsets.all(isTablet ? 28 : 24),
                  child: Column(
                    children: [
                      Container(
                        width: isTablet ? 80 : 70,
                        height: isTablet ? 80 : 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade600, Colors.blue.shade400],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(isTablet ? 40 : 35),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.map_rounded,
                          color: Colors.white,
                          size: isTablet ? 40 : 35,
                        ),
                      ),
                      SizedBox(height: isTablet ? 20 : 16),
                      Text(
                        'Mở Google Maps?',
                        style: TextStyle(
                          fontSize: isTablet ? 24 : 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isTablet ? 12 : 8),
                      Text(
                        'Bạn có muốn mở Google Maps để xem chỉ đường đến VaxPet Veterinary Center không?',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 15,
                          color: AppColors.textGray,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Thông tin địa điểm
                Container(
                  margin: EdgeInsets.symmetric(horizontal: isTablet ? 28 : 24),
                  padding: EdgeInsets.all(isTablet ? 18 : 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blue.shade100,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: isTablet ? 48 : 42,
                        height: isTablet ? 48 : 42,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(isTablet ? 24 : 21),
                        ),
                        child: Icon(
                          Icons.local_hospital_rounded,
                          color: Colors.white,
                          size: isTablet ? 24 : 20,
                        ),
                      ),
                      SizedBox(width: isTablet ? 16 : 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              clinicName ?? '',
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textBlack,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              address ?? '',
                              style: TextStyle(
                                fontSize: isTablet ? 14 : 13,
                                color: AppColors.textGray,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isTablet ? 28 : 24),

                // Action buttons
                Container(
                  padding: EdgeInsets.fromLTRB(
                    isTablet ? 28 : 24,
                    0,
                    isTablet ? 28 : 24,
                    isTablet ? 28 : 24
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: AppColors.textGray.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            'Hủy',
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontSize: isTablet ? 16 : 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 16 : 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.directions_rounded, size: isTablet ? 20 : 18),
                              SizedBox(width: isTablet ? 8 : 6),
                              Text(
                                'Mở Maps',
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 15,
                                  fontWeight: FontWeight.bold,
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
    return result ?? false;
  }

  Future<void> _makePhoneCall() async {
    final url = 'tel:$phone';
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        _showMessage('Không thể thực hiện cuộc gọi', isError: true);
      }
    } catch (e) {
      _showMessage('Lỗi khi gọi điện', isError: true);
    }
  }

  Future<void> _copyAddress() async {
    await Clipboard.setData(ClipboardData(text: address!));
    _showMessage('Đã sao chép địa chỉ');
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade600 : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: BasicAppbar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Địa chỉ phòng khám',
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textWhite,
              ),
            ),
            Text(
              'Tìm đường đến VaxPet',
              style: TextStyle(
                fontSize: isTablet ? 15 : 13,
                color: AppColors.textWhite,
              ),
            ),
          ],
        ),
        hideBack: false,
        elevation: 2,
      ),
      body: BlocListener<GetAddressVaxPetCubit, GetAddressVaxPetState>(
        listener: (context, state) {
          if (state is GetAddressVaxPetSuccess) {
            _updateAddressData(state);
          } else if (state is GetAddressVaxPetFailure) {
            _showMessage(state.message, isError: true);
          }
        },
        child: BlocBuilder<GetAddressVaxPetCubit, GetAddressVaxPetState>(
          builder: (context, state) {
            final clinicStatus = _getClinicStatus();

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Loading indicator khi đang fetch data
                  if (state is GetAddressVaxPetLoading)
                    Container(
                      margin: EdgeInsets.all(isTablet ? 24 : 16),
                      padding: EdgeInsets.all(isTablet ? 32 : 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Đang tải thông tin địa chỉ...',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Map Container
                  if (latitude != null && longitude != null)
                    Container(
                      margin: EdgeInsets.all(isTablet ? 24 : 16),
                      height: screenHeight * (isTablet ? 0.4 : 0.35),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            MapWidget(
                              key: const ValueKey("mapWidget"),
                              cameraOptions: CameraOptions(
                                center: Point(coordinates: Position(longitude!, latitude!)),
                                zoom: 15.0,
                              ),
                              styleUri: MapboxStyles.MAPBOX_STREETS,
                              onMapCreated: _onMapCreated,
                            ),
                            if (_mapLoading)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                  ),
                                ),
                              ),
                            // Map overlay button
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.fullscreen, color: AppColors.primary),
                                  onPressed: _openMapsApp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Placeholder khi chưa có data
                  if (latitude == null || longitude == null)
                    Container(
                      margin: EdgeInsets.all(isTablet ? 24 : 16),
                      height: screenHeight * (isTablet ? 0.4 : 0.35),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map_outlined,
                              size: isTablet ? 80 : 60,
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Đang tải bản đồ...',
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                                color: AppColors.textGray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Clinic Info Card
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      isTablet ? 24 : 16,
                      0,
                      isTablet ? 24 : 16,
                      isTablet ? 24 : 16
                    ),
                    padding: EdgeInsets.all(isTablet ? 28 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with logo
                        Row(
                          children: [
                            Container(
                              width: isTablet ? 60 : 50,
                              height: isTablet ? 60 : 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.local_hospital_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    clinicName ?? '',
                                    style: TextStyle(
                                      fontSize: isTablet ? 20 : 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Hiển thị trạng thái hoạt động của phòng khám
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: clinicStatus['bgColor'],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: clinicStatus['borderColor']),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          clinicStatus['icon'],
                                          color: clinicStatus['color'],
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          clinicStatus['status'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: clinicStatus['color'],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Address Info
                        _buildInfoRow(
                          Icons.location_on_rounded,
                          'Địa chỉ',
                          address ?? '',
                          AppColors.primary,
                          onTap: _copyAddress,
                          isTablet: isTablet,
                        ),

                        const SizedBox(height: 20),

                        // Phone Info
                        _buildInfoRow(
                          Icons.phone_rounded,
                          'Điện thoại',
                          phone,
                          Colors.green.shade600,
                          onTap: _makePhoneCall,
                          isTablet: isTablet,
                        ),

                        const SizedBox(height: 20),

                        // Hours Info
                        _buildInfoRow(
                          Icons.access_time_rounded,
                          'Giờ làm việc',
                          '$openingHours\n${_getNextOpenTime()}',
                          Colors.orange.shade600,
                          isTablet: isTablet,
                        ),

                        const SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.directions_rounded,
                                label: 'Chỉ đường',
                                color: AppColors.primary,
                                onPressed: _openMapsApp,
                                isTablet: isTablet,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.call_rounded,
                                label: 'Gọi điện',
                                color: Colors.green.shade600,
                                onPressed: _makePhoneCall,
                                isTablet: isTablet,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String content,
    Color iconColor, {
    VoidCallback? onTap,
    required bool isTablet,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: iconColor.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: isTablet ? 44 : 40,
              height: isTablet ? 44 : 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: isTablet ? 22 : 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGray,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.touch_app_rounded,
                color: iconColor.withValues(alpha: 0.7),
                size: isTablet ? 20 : 18,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    required bool isTablet,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 16 : 14,
          horizontal: isTablet ? 24 : 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        shadowColor: color.withValues(alpha: 0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isTablet ? 20 : 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
