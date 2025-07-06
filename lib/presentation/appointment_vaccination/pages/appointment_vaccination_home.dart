import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/presentation/main_bottom_navigator/pages/main_bottom_navigator.dart';
import 'package:vaxpet/service_locator.dart';

import '../../../common/widgets/back_button/back_button.dart';
import '../../../common/widgets/reactive_button/reactive_button.dart';
import '../../../data/appointment_vaccination/models/post_appointment_vaccination.dart';
import '../../../domain/appointment_vaccination/usecases/post_appointment_vaccination.dart';
import '../../disease/pages/choice_disease.dart';

class AppointmentVaccinationHomePage extends StatefulWidget {
  final int serviceType = 1; // 1 cho dịch vụ tiêm vắc-xin
  final int location = 2; // 1 cho dịch vụ tại nhà
  final String petName;
  final int petId;
  final String petSpecies;
  final String? petImage;
  const AppointmentVaccinationHomePage({
    super.key,
    required this.petName,
    required this.petId,
    required this.petSpecies,
    this.petImage,
  });

  @override
  State<AppointmentVaccinationHomePage> createState() =>
      _AppointmentVaccinationHomePageState();
}

class _AppointmentVaccinationHomePageState
    extends State<AppointmentVaccinationHomePage> {
  final TextEditingController _dateOfScheduleController =
      TextEditingController();
  final TextEditingController _timeOfScheduleController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  int? _customerId;
  int? _selectedDiseaseId;
  String? _selectedDiseaseName;
  String? _userAddress;
  String?
  _originalAddress; // Lưu trữ địa chỉ gốc từ SharedPreferences khi trang được mở
  bool _isEditingAddress = false;

  // Key để lưu địa chỉ gốc trong SharedPreferences
  final String _originalAddressKey = 'original_address';

  // Parse the date and time separately with validation
  DateTime? selectedDate;
  DateTime? selectedTime;

  String get petSpecies => widget.petSpecies;

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

    return PopScope(
      child: Scaffold(
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
                          'Đặt lịch tiêm vắc xin tại nhà',
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
                                color:
                                    widget.petImage != null
                                        ? Colors.transparent
                                        : Colors.blue[100],
                                shape: BoxShape.circle,
                              ),
                              child:
                                  widget.petImage != null
                                      ? ClipOval(
                                        child: Image.network(
                                          widget.petImage!,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Icon(
                                              Icons.pets,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).primaryColor,
                                              size: 28,
                                            );
                                          },
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                strokeWidth: 2,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).primaryColor,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                      : Icon(
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
                                    widget.petSpecies,
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
                        _buildFormLabel(
                          'Giờ hẹn (8:00-12:00 hoặc 13:00-17:00):',
                        ),
                        SizedBox(height: 8),
                        _buildTimeField(context),
                        SizedBox(height: 20),

                        // Address input
                        _buildFormLabel('Địa chỉ nhà:'),
                        SizedBox(height: 8),
                        _buildAddressField(context),
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
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[800],
                          ),
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
        icon: Icon(Icons.vaccines),
        label: Text('Chọn bệnh cần tiêm'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          textStyle: TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

          // Kiểm tra địa chỉ
          if (_addressController.text.isEmpty) {
            _showSnackBar('Vui lòng nhập địa chỉ nhận dịch vụ', isError: true);
            throw 'Vui lòng nhập địa chỉ nhận dịch vụ';
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
                    _addressController
                        .text, // Sử dụng địa chỉ từ người dùng nhập
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
        _userAddress = prefs.getString(
          'address',
        ); // Lấy địa chỉ người dùng hiện tại

        // Đọc địa chỉ gốc từ SharedPreferences (nếu đã lưu trước đó)
        _originalAddress = prefs.getString(_originalAddressKey);

        // Nếu chưa có địa chỉ gốc được lưu, sử dụng địa chỉ hiện tại làm địa chỉ gốc
        // và lưu vào SharedPreferences để sử dụng sau này
        if (_originalAddress == null && _userAddress != null) {
          _originalAddress = _userAddress;
          prefs.setString(_originalAddressKey, _userAddress!);
          debugPrint('Saved original address: $_originalAddress');
        }

        // Luôn reset địa chỉ về địa chỉ gốc mỗi khi trang được tạo mới
        if (_originalAddress != null && _originalAddress!.isNotEmpty) {
          _addressController.text = _originalAddress!;
          debugPrint('Reset address to original: $_originalAddress');
        }
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

  // Stylized address field
  Widget _buildAddressField(BuildContext context) {
    // Đặt địa chỉ vào controller nếu có và chưa có giá trị
    if (_userAddress != null &&
        _userAddress!.isNotEmpty &&
        _addressController.text.isEmpty) {
      _addressController.text = _userAddress!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: _isEditingAddress ? Colors.white : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  _isEditingAddress
                      ? Theme.of(context).primaryColor
                      : Colors.grey[300]!,
            ),
          ),
          child: TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              hintText:
                  _isEditingAddress
                      ? 'Nhập địa chỉ mới'
                      : 'Đang tải địa chỉ...',
              hintStyle: TextStyle(color: Colors.grey[500]),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
              prefixIcon: Icon(
                Icons.location_on,
                color: Theme.of(context).primaryColor,
              ),
            ),
            style: TextStyle(color: Colors.black87, fontSize: 15),
            maxLines: 2,
            readOnly: !_isEditingAddress,
            enabled: _isEditingAddress,
          ),
        ),

        // Nút đổi địa chỉ và nút nhà bạn được đặt ở phía dưới trường địa chỉ
        if (!_isEditingAddress)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Nút "Nhà bạn" - Để lấy lại địa chỉ gốc đã lưu khi mở form
                GestureDetector(
                  onTap: () {
                    if (_originalAddress != null &&
                        _originalAddress!.isNotEmpty) {
                      setState(() {
                        _addressController.text = _originalAddress!;
                        // Không cập nhật _userAddress để không ảnh hưởng đến giá trị hiện tại
                      });
                      _showSnackBar(
                        'Đã lấy lại địa chỉ nhà bạn',
                        isError: false,
                        icon: Icons.home,
                      );
                    } else {
                      _showSnackBar(
                        'Không tìm thấy địa chỉ đã lưu',
                        isError: true,
                        icon: Icons.warning,
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Nhà bạn',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                // Nút đổi địa chỉ
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditingAddress = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
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
                          Icons.edit,
                          color: Theme.of(context).primaryColor,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Đổi địa chỉ',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Các nút lưu và hủy khi đang chỉnh sửa
        if (_isEditingAddress)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      // Khôi phục giá trị ban đầu
                      _addressController.text = _userAddress ?? '';
                      _isEditingAddress = false;
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                  ),
                  child: Text('Hủy'),
                ),
                SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_addressController.text.trim().isEmpty) {
                      _showSnackBar('Vui lòng nhập địa chỉ', isError: true);
                      return;
                    }

                    setState(() {
                      // Lưu địa chỉ mới vào biến _userAddress
                      _userAddress = _addressController.text;
                      _isEditingAddress = false;
                    });

                    try {
                      // Lưu địa chỉ mới vào SharedPreferences
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('address', _addressController.text);
                      _showSnackBar(
                        'Đã cập nhật địa chỉ thành công',
                        isError: false,
                        icon: Icons.check_circle,
                      );
                    } catch (e) {
                      debugPrint('Error saving address: $e');
                      _showSnackBar('Không thể lưu địa chỉ: $e', isError: true);
                    }
                  },
                  icon: Icon(Icons.save, size: 18),
                  label: Text('Lưu'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class TimeOfDayRange {
  final TimeOfDay start;
  final TimeOfDay end;
  final Color color;
  final String label;

  TimeOfDayRange(this.start, this.end, this.color, this.label);
}
