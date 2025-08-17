import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/presentation/main_bottom_navigator/pages/main_bottom_navigator.dart';
import 'package:vaxpet/service_locator.dart';

import '../../../common/widgets/back_button/back_button.dart';
import '../../../common/widgets/reactive_button/reactive_button.dart';
import '../../../data/appointment_vaccination/models/post_appointment_vaccination.dart';
import '../../../domain/appointment_vaccination/usecases/post_appointment_vaccination.dart';
import '../../disease/pages/choice_disease.dart';

class AppointmentVaccinationClinicPage extends StatefulWidget {
  final int serviceType = 1; // 1 cho dịch vụ tiêm vắc-xin
  final int location = 1; // 1 cho dịch vụ tại trung tâm
  final String petName;
  final int petId;
  final String petSpecies;
  const AppointmentVaccinationClinicPage({
    super.key,
    required this.petName,
    required this.petId,
    required this.petSpecies,
  });

  @override
  State<AppointmentVaccinationClinicPage> createState() =>
      _AppointmentVaccinationClinicPageState();
}

class _AppointmentVaccinationClinicPageState
    extends State<AppointmentVaccinationClinicPage> {
  final TextEditingController _dateOfScheduleController =
      TextEditingController();
  final TextEditingController _timeOfScheduleController =
      TextEditingController();
  int? _customerId;
  int? _selectedDiseaseId;
  String? _selectedDiseaseName;

  // Parse the date and time separately with validation
  DateTime? selectedDate;
  DateTime? selectedTime;

  String get petSpecies => widget.petSpecies;

  // Helper method to translate pet species to Vietnamese
  String _getVietnamesePetSpecies(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
      case 'chó':
        return 'Chó';
      case 'cat':
      case 'mèo':
        return 'Mèo';
      default:
        return species; // Return original if no translation found
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCustomerId();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình để tính toán responsive
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final bool isTablet = screenWidth > 600;

    // Tính toán padding dựa trên kích thước màn hình
    final double horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button ở góc trái trên cùng
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: screenHeight * 0.01,
                  left: horizontalPadding,
                ),
                child: BackButtonBasic(),
              ),

              // Header section with title and pet info
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề trang
                    Center(
                      child: Text(
                        'Đặt lịch tiêm vắc xin tại trung tâm',
                        style: TextStyle(
                          fontSize: isTablet ? 28 : 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Pet info card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.pets,
                              color: Theme.of(context).primaryColor,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.petName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _getVietnamesePetSpecies(widget.petSpecies),
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
                    ),

                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),

              // Form Section
              Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form title
                      Text(
                        'Thông tin lịch hẹn',
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Divider(height: 30, thickness: 1),

                      // Date selection
                      _buildFormLabel('Ngày hẹn tiêm vắc xin:'),
                      SizedBox(height: 8),
                      _buildDateField(context),
                      SizedBox(height: 20),

                      // Time selection
                      _buildFormLabel('Giờ hẹn (8:00-12:00 hoặc 13:00-17:00):'),
                      SizedBox(height: 8),
                      _buildTimeField(context),
                      SizedBox(height: 20),

                      // Disease selection button
                      _buildFormLabel('Bệnh cần tiêm vắc xin:'),
                      SizedBox(height: 8),
                      _buildDiseaseSelectionButton(context),
                      SizedBox(height: 16),

                      // Disease selection result
                      _buildDiseaseSelectionResult(),
                      SizedBox(height: 24),

                      // Submit button
                      _buildSubmitButton(context),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Note section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue[700],
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Lưu ý',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Bạn sẽ được Bác sĩ tư vấn loại Vắc xin tương ứng với bệnh bạn chọn sau!',
                        style: TextStyle(fontSize: 14, color: Colors.blue[800]),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  // Text label for form fields
  Widget _buildFormLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Colors.grey[800],
      ),
    );
  }

  // Stylized date field
  Widget _buildDateField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextFormField(
        controller: _dateOfScheduleController,
        decoration: InputDecoration(
          hintText: 'Chọn ngày mong muốn',
          hintStyle: TextStyle(color: Colors.grey[500]),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          suffixIcon: Icon(
            Icons.calendar_today,
            color: Theme.of(context).primaryColor,
          ),
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.datetime,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          final tomorrow = DateTime.now().add(const Duration(days: 1));

          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: tomorrow,
            firstDate: tomorrow,
            lastDate: DateTime.now().add(const Duration(days: 365)),
            locale: const Locale('vi', 'VN'),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: Theme.of(context).primaryColor,
                  colorScheme: ColorScheme.light(
                    primary: Theme.of(context).primaryColor,
                  ),
                  buttonTheme: const ButtonThemeData(
                    textTheme: ButtonTextTheme.primary,
                  ),
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            String formattedDate =
                "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
            _dateOfScheduleController.text = formattedDate;
            selectedDate = pickedDate;

            // Hiển thị thông báo khi chọn ngày thành công
            _showSnackBar(
              'Đã chọn ngày hẹn: $formattedDate',
              isError: false,
              icon: Icons.calendar_month,
            );
          }
        },
      ),
    );
  }

  // Stylized time field with beautiful time picker
  Widget _buildTimeField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextFormField(
        controller: _timeOfScheduleController,
        decoration: InputDecoration(
          hintText: 'Chọn giờ mong muốn',
          hintStyle: TextStyle(color: Colors.grey[500]),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          suffixIcon: Icon(
            Icons.access_time,
            color: Theme.of(context).primaryColor,
          ),
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.datetime,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());

          TimeOfDay initialTime = TimeOfDay.now();
          if (_timeOfScheduleController.text.isNotEmpty) {
            try {
              final timeParts = _timeOfScheduleController.text.split(':');
              initialTime = TimeOfDay(
                hour: int.parse(timeParts[0]),
                minute: int.parse(timeParts[1]),
              );
            } catch (_) {}
          }

          if (!_isTimeInAllowedRanges(initialTime)) {
            initialTime = const TimeOfDay(hour: 8, minute: 0);
          }

          // Customize time picker appearance
          final ThemeData theme = Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              dayPeriodColor: Colors.blue.shade50,
              dayPeriodTextColor: Colors.blue.shade700,
              hourMinuteColor: WidgetStateColor.resolveWith(
                (states) =>
                    states.contains(WidgetState.selected)
                        ? Theme.of(context).primaryColor
                        : Colors.blue.shade50,
              ),
              hourMinuteTextColor: WidgetStateColor.resolveWith(
                (states) =>
                    states.contains(WidgetState.selected)
                        ? Colors.white
                        : Colors.blue.shade700,
              ),
              dialBackgroundColor: Colors.grey.shade100,
              dialHandColor: Theme.of(context).primaryColor,
              dialTextColor: WidgetStateColor.resolveWith(
                (states) =>
                    states.contains(WidgetState.selected)
                        ? Colors.white
                        : Colors.black87,
              ),
              entryModeIconColor: Theme.of(context).primaryColor,
            ),
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
              surface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          );

          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: initialTime,
            cancelText: 'Huỷ',
            confirmText: 'Chọn',
            helpText: 'Chọn giờ hẹn',
            hourLabelText: 'Giờ',
            minuteLabelText: 'Phút',
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: theme,
                child: MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                ),
              );
            },
          );

          if (pickedTime != null) {
            if (_isTimeInAllowedRanges(pickedTime)) {
              final hour = pickedTime.hour.toString().padLeft(2, '0');
              final minute = pickedTime.minute.toString().padLeft(2, '0');
              _timeOfScheduleController.text = "$hour:$minute";

              // Show time confirmation with appropriate color
              final bool isMorningTime = pickedTime.hour < 12;
              _showSnackBar(
                'Đã chọn giờ hẹn: $hour:$minute',
                isError: false,
                icon: isMorningTime ? Icons.sunny : Icons.wb_twilight,
                color:
                    isMorningTime
                        ? Colors.amber.shade700
                        : Colors.indigo.shade700,
              );
            } else {
              _showSnackBar(
                'Vui lòng chọn giờ trong khoảng 8:00-12:00 hoặc 13:00-17:00',
                isError: true,
              );
            }
          }
        },
      ),
    );
  }

  // Helper method to check if time is in allowed ranges
  bool _isTimeInAllowedRanges(TimeOfDay time) {
    final morningStart = const TimeOfDay(hour: 8, minute: 0);
    final morningEnd = const TimeOfDay(hour: 12, minute: 0);
    final afternoonStart = const TimeOfDay(hour: 13, minute: 0);
    final afternoonEnd = const TimeOfDay(hour: 17, minute: 0);

    // Convert to minutes for easier comparison
    final timeInMinutes = time.hour * 60 + time.minute;
    final morningStartMinutes = morningStart.hour * 60 + morningStart.minute;
    final morningEndMinutes = morningEnd.hour * 60 + morningEnd.minute;
    final afternoonStartMinutes =
        afternoonStart.hour * 60 + afternoonStart.minute;
    final afternoonEndMinutes = afternoonEnd.hour * 60 + afternoonEnd.minute;

    // Check if time is in morning range (8:00-12:00) or afternoon range (13:00-17:00)
    return (timeInMinutes >= morningStartMinutes &&
            timeInMinutes <= morningEndMinutes) ||
        (timeInMinutes >= afternoonStartMinutes &&
            timeInMinutes <= afternoonEndMinutes);
  }

  // Disease selection button
  Widget _buildDiseaseSelectionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final result = await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(
              builder: (context) => ChoiceDiseasePage(species: petSpecies),
            ),
          );

          if (result != null && mounted) {
            setState(() {
              _selectedDiseaseId = result['diseaseId'];
              _selectedDiseaseName = result['diseaseName'];
            });
          }
        },
        icon: Icon(Icons.vaccines, color: Colors.white),
        label: Text(
          'Chọn bệnh cần tiêm',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // Màu xanh nổi bật
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          shadowColor: Colors.blue.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  // Disease selection result display
  Widget _buildDiseaseSelectionResult() {
    if (_selectedDiseaseName != null) {
      return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Bệnh đã chọn: $_selectedDiseaseName',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Vui lòng chọn bệnh cần tiêm vắc xin',
                style: TextStyle(fontSize: 15, color: Colors.orange),
              ),
            ),
          ],
        ),
      );
    }
  }

  // Submit button with improved design
  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ReactiveButton(
        onPressed: () async {
          if (_customerId == null) {
            _showSnackBar('Không tìm thấy thông tin người dùng', isError: true);
            throw 'Không tìm thấy thông tin người dùng';
          }

          // Kiểm tra trường ngày
          if (_dateOfScheduleController.text.isEmpty) {
            _showSnackBar('Vui lòng chọn ngày hẹn', isError: true);
            throw 'Vui lòng chọn ngày hẹn';
          }

          // Kiểm tra trường giờ
          if (_timeOfScheduleController.text.isEmpty) {
            _showSnackBar('Vui lòng chọn giờ hẹn', isError: true);
            throw 'Vui lòng chọn giờ hẹn';
          }

          // Kiểm tra bệnh đã chọn
          if (_selectedDiseaseId == null) {
            _showSnackBar('Vui lòng chọn bệnh cần tiêm vắc-xin', isError: true);
            throw 'Vui lòng chọn bệnh cần tiêm vắc-xin';
          }

          try {
            try {
              selectedDate = DateFormat(
                'dd/MM/yyyy',
              ).parse(_dateOfScheduleController.text);
            } catch (e) {
              _showSnackBar('Định dạng ngày không hợp lệ', isError: true);
              throw 'Định dạng ngày không hợp lệ';
            }

            try {
              selectedTime = DateFormat(
                'HH:mm',
              ).parse(_timeOfScheduleController.text);
            } catch (e) {
              _showSnackBar('Định dạng giờ không hợp lệ', isError: true);
              throw 'Định dạng giờ không hợp lệ';
            }

            // Combine date and time
            final combinedDateTime = DateTime(
              selectedDate!.year,
              selectedDate!.month,
              selectedDate!.day,
              selectedTime!.hour,
              selectedTime!.minute,
            );

            // Format as ISO 8601 with milliseconds and Z timezone
            final formattedDate = DateFormat(
              "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
            ).format(combinedDateTime);

            final result = await sl<PostAppointmentVaccinationUseCase>().call(
              params: PostAppointmentVaccinationModel(
                customerId: _customerId!,
                petId: widget.petId,
                appointmentDate: formattedDate,
                serviceType: widget.serviceType,
                location: widget.location,
                address:
                    "Địa chỉ mặc định", // Sử dụng địa chỉ mặc định thay vì nhập
                diseaseId: _selectedDiseaseId!,
              ),
            );

            return result;
          } catch (e) {
            debugPrint('Error creating vaccination schedule: $e');
            _showSnackBar('Đã xảy ra lỗi: $e', isError: true);
            rethrow;
          }
        },
        title: 'Đặt lịch ngay',
        onSuccess: () {
          _showSnackBar('Đặt lịch thành công');
          AppNavigator.pushAndRemove(context, MainBottomNavigatorPage());
        },
        onFailure: (error) {
          debugPrint('Error creating vaccination schedule: $error');
          _showSnackBar(error, isError: true);
        },
      ),
    );
  }

  // Phương thức lấy customerId từ SharedPreferences
  Future<void> _loadCustomerId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _customerId = prefs.getInt('customerId');
      });

      if (_customerId == null) {
        debugPrint(
          'Warning: customerId không tìm thấy trong SharedPreferences',
        );
      } else {
        debugPrint('Loaded customerId: $_customerId');
      }
    } catch (e) {
      debugPrint('Error loading customerId: $e');
    }
  }

  // Hàm hiển thị thông báo ở phía trên màn hình
  void _showSnackBar(
    String message, {
    bool isError = false,
    IconData? icon,
    Color? color,
  }) {
    // Hủy bỏ thông báo hiện tại (nếu có)
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Tạo một Overlay để hiển thị thông báo ở phía trên
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).viewPadding.top + 10,
            left: 10,
            right: 10,
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8),
              color: isError ? Colors.red : color ?? Colors.green,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        overlayEntry?.remove();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Đóng',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    // Hiển thị overlay
    overlayState.insert(overlayEntry);

    // Tự động ẩn sau 3 giây
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry?.remove();
    });
  }
}

class TimeOfDayRange {
  final TimeOfDay start;
  final TimeOfDay end;
  final Color color;
  final String label;

  TimeOfDayRange(this.start, this.end, this.color, this.label);
}
