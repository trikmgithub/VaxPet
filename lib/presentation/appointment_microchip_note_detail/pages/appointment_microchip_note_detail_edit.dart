import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/appointment_microchip_note_detail_edit_cubit.dart';
import '../bloc/appointment_microchip_note_detail_edit_state.dart';
import '../../../common/widgets/back_button/back_button.dart';

class AppointmentMicrochipNoteDetailEditPage extends StatefulWidget {
  final Map<String, dynamic> appointmentData;

  const AppointmentMicrochipNoteDetailEditPage({
    super.key,
    required this.appointmentData,
  });

  @override
  State<AppointmentMicrochipNoteDetailEditPage> createState() =>
      _AppointmentMicrochipNoteDetailEditPageState();
}

class _AppointmentMicrochipNoteDetailEditPageState
    extends State<AppointmentMicrochipNoteDetailEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _originalAddress;
  String? _userAddress;
  bool _isEditingAddress = false; // Add this as class-level state variable

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _loadUserAddress();
  }

  void _initializeForm() {
    // Access appointment data directly (microchip structure)
    final appointment = widget.appointmentData;

    // Initialize form fields
    _addressController.text = appointment['address'] ?? '';
    _originalAddress = appointment['address'] ?? '';

    // Parse and format the appointment date
    if (appointment['appointmentDate'] != null) {
      final dateTime = DateTime.parse(appointment['appointmentDate']);
      _selectedDate = dateTime;
      _selectedTime = TimeOfDay.fromDateTime(dateTime);
      _dateController.text = DateFormat('dd/MM/yyyy').format(dateTime);
      _timeController.text = DateFormat('HH:mm').format(dateTime);
    }

    // Initialize cubit with current data
    context
        .read<AppointmentMicrochipNoteDetailEditCubit>()
        .initializeWithData(
          appointmentId: appointment['appointmentId'],
          customerId: appointment['customerId'],
          petId: appointment['petId'],
          appointmentDate: appointment['appointmentDate'],
          serviceType: appointment['serviceType'],
          location: appointment['location'],
          address: appointment['address'] ?? '',
        );
  }

  Future<void> _loadUserAddress() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _userAddress = prefs.getString('address');
      });
    } catch (e) {
      debugPrint('Error loading user address: $e');
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? tomorrow,
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

    if (picked != null) {
      String formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      setState(() {
        _selectedDate = picked;
        _dateController.text = formattedDate;
      });
      _updateDateTime();
      _showSnackBar(
        'Đã chọn ngày hẹn: $formattedDate',
        isError: false,
        icon: Icons.calendar_month,
      );
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay initialTime =
        _selectedTime ?? const TimeOfDay(hour: 8, minute: 0);

    if (!_isTimeInAllowedRanges(initialTime)) {
      initialTime = const TimeOfDay(hour: 8, minute: 0);
    }

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

    TimeOfDay? picked = await showTimePicker(
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
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      if (_isTimeInAllowedRanges(picked)) {
        setState(() {
          _selectedTime = picked;
          final hour = picked.hour.toString().padLeft(2, '0');
          final minute = picked.minute.toString().padLeft(2, '0');
          _timeController.text = "$hour:$minute";
        });
        _updateDateTime();

        final bool isMorningTime = picked.hour < 12;
        _showSnackBar(
          'Đã chọn giờ hẹn: ${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
          isError: false,
          icon: isMorningTime ? Icons.sunny : Icons.wb_twilight,
          color: isMorningTime ? Colors.amber.shade700 : Colors.indigo.shade700,
        );
      } else {
        _showSnackBar(
          'Vui lòng chọn giờ trong khoảng 8:00-12:00 hoặc 13:00-17:00',
          isError: true,
        );
      }
    }
  }

  bool _isTimeInAllowedRanges(TimeOfDay time) {
    final morningStart = const TimeOfDay(hour: 8, minute: 0);
    final morningEnd = const TimeOfDay(hour: 12, minute: 0);
    final afternoonStart = const TimeOfDay(hour: 13, minute: 0);
    final afternoonEnd = const TimeOfDay(hour: 17, minute: 0);

    final timeInMinutes = time.hour * 60 + time.minute;
    final morningStartMinutes = morningStart.hour * 60 + morningStart.minute;
    final morningEndMinutes = morningEnd.hour * 60 + morningEnd.minute;
    final afternoonStartMinutes =
        afternoonStart.hour * 60 + afternoonStart.minute;
    final afternoonEndMinutes = afternoonEnd.hour * 60 + afternoonEnd.minute;

    return (timeInMinutes >= morningStartMinutes &&
            timeInMinutes <= morningEndMinutes) ||
        (timeInMinutes >= afternoonStartMinutes &&
            timeInMinutes <= afternoonEndMinutes);
  }

  void _updateDateTime() {
    if (_selectedDate != null && _selectedTime != null) {
      final combinedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      context
          .read<AppointmentMicrochipNoteDetailEditCubit>()
          .updateAppointmentDate(combinedDateTime.toIso8601String());
    }
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
        controller: _dateController,
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
          await _selectDate();
        },
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Vui lòng chọn ngày hẹn';
          }
          return null;
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
        controller: _timeController,
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
          await _selectTime();
        },
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Vui lòng chọn giờ hẹn';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLocationField(AppointmentMicrochipNoteDetailEditState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<int>(
        value: state.location,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.location_on,
            color: Theme.of(context).primaryColor,
          ),
        ),
        items: const [
          DropdownMenuItem(value: 1, child: Text('Trung tâm')),
          DropdownMenuItem(value: 2, child: Text('Tại nhà')),
        ],
        onChanged: (value) {
          if (value != null) {
            context
                .read<AppointmentMicrochipNoteDetailEditCubit>()
                .updateLocation(value);
          }
        },
      ),
    );
  }

  // Stylized address field exactly like in vaccination home
  Widget _buildAddressField() {

    // Set address to controller if available and controller is empty
    if (_userAddress != null &&
        _userAddress!.isNotEmpty &&
        _addressController.text.isEmpty) {
      _addressController.text = _userAddress!;
    }

    return StatefulBuilder(
      builder: (context, setAddressState) {
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
                      _isEditingAddress ? 'Nhập địa chỉ mới' : 'Địa chỉ hiện tại',
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
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
                onChanged: (value) {
                  context
                      .read<AppointmentMicrochipNoteDetailEditCubit>()
                      .updateAddress(value);
                },
              ),
            ),

            // Nút đổi địa chỉ và nút nhà bạn được đặt ở phía dưới trường địa chỉ
            if (!_isEditingAddress)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;
                    final isSmallScreen = screenWidth < 350;
                    final isMediumScreen = screenWidth < 500;

                    // Responsive button sizing with three tiers
                    final buttonPadding =
                        isSmallScreen
                            ? EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                            : isMediumScreen
                            ? EdgeInsets.symmetric(horizontal: 10, vertical: 5)
                            : EdgeInsets.symmetric(horizontal: 12, vertical: 6);

                    final buttonFontSize =
                        isSmallScreen
                            ? 12.0
                            : isMediumScreen
                            ? 13.0
                            : 14.0;
                    final iconSize =
                        isSmallScreen
                            ? 14.0
                            : isMediumScreen
                            ? 15.0
                            : 16.0;
                    final spacingBetween =
                        isSmallScreen
                            ? 4.0
                            : isMediumScreen
                            ? 6.0
                            : 8.0;

                    return Wrap(
                      alignment: WrapAlignment.end,
                      spacing: spacingBetween,
                      runSpacing: 8.0,
                      children: [
                        // Nút "Địa chỉ gốc" - Để lấy lại địa chỉ gốc đã lưu khi mở form
                        GestureDetector(
                          onTap: () {
                            if (_originalAddress != null &&
                                _originalAddress!.isNotEmpty) {
                              setAddressState(() {
                                _addressController.text = _originalAddress!;
                              });
                              context
                                  .read<AppointmentMicrochipNoteDetailEditCubit>()
                                  .updateAddress(_originalAddress!);
                              _showSnackBar(
                                'Đã lấy lại địa chỉ gốc',
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
                            padding: buttonPadding,
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
                                Icon(
                                  Icons.home,
                                  color: Colors.green,
                                  size: iconSize,
                                ),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    isSmallScreen ? 'Ban đầu' : 'Địa chỉ ban đầu',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: buttonFontSize,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Nút "Nhà bạn" - Để lấy địa chỉ từ SharedPreferences
                        GestureDetector(
                          onTap: () {
                            if (_userAddress != null && _userAddress!.isNotEmpty) {
                              setAddressState(() {
                                _addressController.text = _userAddress!;
                              });
                              context
                                  .read<AppointmentMicrochipNoteDetailEditCubit>()
                                  .updateAddress(_userAddress!);
                              _showSnackBar(
                                'Đã sử dụng địa chỉ nhà bạn',
                                isError: false,
                                icon: Icons.location_city,
                                color: Colors.purple,
                              );
                            } else {
                              _showSnackBar(
                                'Không tìm thấy địa chỉ nhà bạn đã lưu',
                                isError: true,
                                icon: Icons.warning,
                              );
                            }
                          },
                          child: Container(
                            padding: buttonPadding,
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.purple.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_city,
                                  color: Colors.purple,
                                  size: iconSize,
                                ),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Nhà bạn',
                                    style: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: buttonFontSize,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Nút đổi địa chỉ
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isEditingAddress = true;
                            });
                          },
                          child: Container(
                            padding: buttonPadding,
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
                                  size: iconSize,
                                ),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    isSmallScreen ? 'Đổi' : 'Đổi địa chỉ',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: buttonFontSize,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
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
                          _addressController.text = _originalAddress ?? '';
                          _isEditingAddress = false;
                        });
                        context
                            .read<AppointmentMicrochipNoteDetailEditCubit>()
                            .updateAddress(_originalAddress ?? '');
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
                          _isEditingAddress = false;
                        });

                        context
                            .read<AppointmentMicrochipNoteDetailEditCubit>()
                            .updateAddress(_addressController.text);

                        _showSnackBar(
                          'Đã cập nhật địa chỉ thành công',
                          isError: false,
                          icon: Icons.check_circle,
                        );
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
      },
    );
  }

  // Submit button with custom implementation instead of ReactiveButton
  Widget _buildUpdateButton(AppointmentMicrochipNoteDetailEditState state) {
    return StatefulBuilder(
      builder: (context, setButtonState) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed:
                state.status == AppointmentMicrochipNoteDetailEditStatus.loading
                    ? null
                    : () async {
                      try {
                        if (!(_formKey.currentState?.validate() ?? false)) {
                          _showSnackBar(
                            'Vui lòng điền đầy đủ thông tin',
                            isError: true,
                          );
                          return;
                        }

                        // Call the update method
                        await context
                            .read<AppointmentMicrochipNoteDetailEditCubit>()
                            .updateAppointment();
                      } catch (e) {
                        debugPrint('Error updating appointment: $e');
                        _showSnackBar(e.toString(), isError: true);
                      }
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[400],
              elevation:
                  state.status == AppointmentMicrochipNoteDetailEditStatus.loading
                      ? 0
                      : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                state.status == AppointmentMicrochipNoteDetailEditStatus.loading
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Đang cập nhật...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                    : Text(
                      'Cập nhật lịch hẹn',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ),
        );
      },
    );
  }

  Widget _buildNoteSection() {
    return Container(
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
              Icon(Icons.info_outline, color: Colors.blue[700], size: 18),
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
            'Vui lòng đến đúng giờ hẹn và mang theo giấy tờ cần thiết để thực hiện dịch vụ cấy chip cho thú cưng!',
            style: TextStyle(fontSize: 14, color: Colors.blue[800]),
          ),
        ],
      ),
    );
  }

  // Hàm hiển thị thông báo ở phía trên màn hình giống như vaccination home
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

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final bool isTablet = screenWidth > 600;
    final double horizontalPadding = screenWidth * 0.05;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        // No special handling needed, just allow normal back navigation
      },
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
                          'Chỉnh sửa lịch cấy chip',
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
                      _buildPetInfoCard(),

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
                    child: BlocConsumer<
                      AppointmentMicrochipNoteDetailEditCubit,
                      AppointmentMicrochipNoteDetailEditState
                    >(
                      listener: (context, state) {
                        if (state.status ==
                            AppointmentMicrochipNoteDetailEditStatus.success) {
                          _showSnackBar(
                            'Cập nhật lịch hẹn thành công!',
                            isError: false,
                            icon: Icons.check_circle,
                          );
                          Navigator.of(context).pop(true);
                        } else if (state.status ==
                            AppointmentMicrochipNoteDetailEditStatus.failure) {
                          _showSnackBar(
                            state.errorMessage ?? 'Có lỗi xảy ra',
                            isError: true,
                          );
                        }
                      },
                      builder: (context, state) {
                        return Form(
                          key: _formKey,
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

                              _buildFormLabel('Ngày hẹn cấy chip:'),
                              const SizedBox(height: 8),
                              _buildDateField(context),
                              const SizedBox(height: 20),

                              _buildFormLabel(
                                'Giờ hẹn (8:00-12:00 hoặc 13:00-17:00):',
                              ),
                              const SizedBox(height: 8),
                              _buildTimeField(context),
                              const SizedBox(height: 20),

                              _buildFormLabel('Địa điểm:'),
                              const SizedBox(height: 8),
                              _buildLocationField(state),

                              // Chỉ hiển thị địa chỉ khi location = 2 (Tại nhà)
                              if (state.location == 2) ...[
                                const SizedBox(height: 20),
                                _buildFormLabel('Địa chỉ:'),
                                const SizedBox(height: 8),
                                _buildAddressField(),
                              ],

                              const SizedBox(height: 24),

                              _buildUpdateButton(state),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),

                // Note section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: _buildNoteSection(),
                ),

                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPetInfoCard() {
    final appointment = widget.appointmentData;
    final petData = appointment['petResponseDTO'];
    final petName = petData['name'] ?? 'Không xác định';
    final petSpecies = petData['species'] ?? 'Không xác định';
    final petImage = petData['image'];

    return Container(
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
              color: petImage != null ? Colors.transparent : Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child:
                petImage != null
                    ? ClipOval(
                      child: Image.network(
                        petImage,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.pets,
                            color: Theme.of(context).primaryColor,
                            size: 28,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                              strokeWidth: 2,
                              color: Theme.of(context).primaryColor,
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
                  petName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  petSpecies.toLowerCase() == 'dog' ? 'Chó' : 'Mèo',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
