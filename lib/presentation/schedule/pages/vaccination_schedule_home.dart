import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/data/schedule/models/create_app_vac_req_params.dart';
import 'package:vaxpet/domain/schedule/usecases/create_app_vac.dart';
import 'package:vaxpet/service_locator.dart';

import '../../../common/widgets/back_button/back_button.dart';
import '../../../common/widgets/reactive_button/reactive_button.dart';
import '../../pet/widgets/category_text.dart';
import '../../disease/pages/choice_disease.dart';



class VaccinationScheduleHomePage extends StatefulWidget {
  final int serviceType = 1; // 1 cho dịch vụ tiêm vắc-xin
  final int location = 1; // 1 cho dịch vụ tại nhà
  final String petName;
  final int petId;
  final String petSpecies;
  const VaccinationScheduleHomePage({
    super.key,
    required this.petName,
    required this.petId,
    required this.petSpecies,
  });

  @override
  State<VaccinationScheduleHomePage> createState() => _VaccinationScheduleHomePageState();
}

class _VaccinationScheduleHomePageState extends State<VaccinationScheduleHomePage> {
  final TextEditingController _dateOfScheduleController = TextEditingController();
  final TextEditingController _timeOfScheduleController = TextEditingController();
  int? _customerId;
  int? _selectedDiseaseId;
  String? _selectedDiseaseName;

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
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 0, right: 24, left: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButtonBasic(),
            Center(
              child: CategoryText(
                title: 'Thông tin lịch hẹn tiêm vắc xin tại nhà',
                sizeTitle: 20,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            CategoryText(title: widget.petName),
            const SizedBox(height: 16),
            _dateOfSchedule(context),
            const SizedBox(height: 16),
            _timeOfSchedule(context),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(builder: (context) => ChoiceDiseasePage(species: petSpecies)),
                );

                if (result != null && mounted) {
                  setState(() {
                    _selectedDiseaseId = result['diseaseId'];
                    _selectedDiseaseName = result['diseaseName'];
                  });
                }
              },
              child: const Text('Chọn bệnh cần tiêm vắc xin', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            if (_selectedDiseaseName != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bệnh đã chọn: $_selectedDiseaseName',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Vui lòng chọn bệnh cần tiêm vắc xin',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            SizedBox(height: 16),
            _buttonSubmit(context),
          ],
        ),
      ),
    );
  }

  Widget _dateOfSchedule(BuildContext context) {
    return TextFormField(
      controller: _dateOfScheduleController,
      decoration: const InputDecoration(
        labelText: 'Ngày hẹn tiêm vắc xin',
        hintText: 'Chọn ngày mong muốn tiêm vắc xin',
      ),
      keyboardType: TextInputType.datetime,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (pickedDate != null) {
          // format date dd/mm/yyyy
          String formattedDate =
              "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
          _dateOfScheduleController.text = formattedDate;
        }
      },
    );
  }

  Widget _timeOfSchedule(BuildContext context) {
    return TextFormField(
      controller: _timeOfScheduleController,
      decoration: const InputDecoration(
        labelText: 'Giờ hẹn tiêm vắc xin',
        hintText: 'Chọn giờ trong khoảng 9:00-12:00 hoặc 14:00-17:00',
      ),
      keyboardType: TextInputType.datetime,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());

        // Get current selected time or use default
        TimeOfDay initialTime = TimeOfDay.now();
        if (_timeOfScheduleController.text.isNotEmpty) {
          try {
            final timeParts = _timeOfScheduleController.text.split(':');
            initialTime = TimeOfDay(
              hour: int.parse(timeParts[0]),
              minute: int.parse(timeParts[1])
            );
          } catch (_) {}
        }

        // Ensure initial time is within allowed ranges, otherwise set to 9:00
        if (!_isTimeInAllowedRanges(initialTime)) {
          initialTime = const TimeOfDay(hour: 9, minute: 0);
        }

        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
          cancelText: 'Huỷ',
          confirmText: 'Chọn',
          helpText: 'Chọn giờ',
          hourLabelText: 'Giờ',
          minuteLabelText: 'Phút',
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );

        if (pickedTime != null) {
          // Check if the selected time is within allowed ranges
          if (_isTimeInAllowedRanges(pickedTime)) {
            // Format time as HH:mm
            final hour = pickedTime.hour.toString().padLeft(2, '0');
            final minute = pickedTime.minute.toString().padLeft(2, '0');
            _timeOfScheduleController.text = "$hour:$minute";
          } else {
            // Show error message if time is not in allowed range
            _showSnackBar(
              'Vui lòng chọn giờ trong khoảng 9:00-12:00 hoặc 14:00-17:00',
              isError: true
            );
          }
        }
      },
    );
  }

  Widget _buttonSubmit(BuildContext context) {
    return ReactiveButton(
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
            selectedDate = DateFormat('dd/MM/yyyy').parse(_dateOfScheduleController.text);
          } catch (e) {
            _showSnackBar('Định dạng ngày không hợp lệ', isError: true);
          }

          try {
            selectedTime = DateFormat('HH:mm').parse(_timeOfScheduleController.text);
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
          final formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(combinedDateTime);

          final result = await sl<CreateAppVacUseCase>().call(params: CreateAppVacReqParams(
              customerId: _customerId!,
              petId: widget.petId,
              appointmentDate: formattedDate,
              serviceType: widget.serviceType,
              location: widget.location,
              address: "Địa chỉ mặc định", // Có thể thay đổi nếu cần
              diseaseId: _selectedDiseaseId!
          ));

          return result;

        } catch (e) {
          debugPrint('Error creating vaccination schedule: $e');
          _showSnackBar('Đã xảy ra lỗi: $e', isError: true);
        }
      },
      title: 'Đặt lịch',
      onSuccess: () {
        // Thành công đã được xử lý trong _createVaccinationSchedule
        _showSnackBar('Đặt lịch thành công');
      },
      onFailure: (error) {
        debugPrint('Error creating vaccination schedule: $error');
        _showSnackBar(error, isError: true);
      },
    );

  }

  // Helper method to check if time is in allowed ranges
  bool _isTimeInAllowedRanges(TimeOfDay time) {
    final morningStart = const TimeOfDay(hour: 9, minute: 0);
    final morningEnd = const TimeOfDay(hour: 12, minute: 0);
    final afternoonStart = const TimeOfDay(hour: 14, minute: 0);
    final afternoonEnd = const TimeOfDay(hour: 17, minute: 0);

    // Convert to minutes for easier comparison
    final timeInMinutes = time.hour * 60 + time.minute;
    final morningStartMinutes = morningStart.hour * 60 + morningStart.minute;
    final morningEndMinutes = morningEnd.hour * 60 + morningEnd.minute;
    final afternoonStartMinutes = afternoonStart.hour * 60 + afternoonStart.minute;
    final afternoonEndMinutes = afternoonEnd.hour * 60 + afternoonEnd.minute;

    // Check if time is in morning range (9:00-12:00) or afternoon range (14:00-17:00)
    return (timeInMinutes >= morningStartMinutes && timeInMinutes <= morningEndMinutes) ||
           (timeInMinutes >= afternoonStartMinutes && timeInMinutes <= afternoonEndMinutes);
  }

  // Phương thức lấy customerId từ SharedPreferences
  Future<void> _loadCustomerId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _customerId = prefs.getInt('customerId');
      });

      if (_customerId == null) {
        debugPrint('Warning: customerId không tìm thấy trong SharedPreferences');
      } else {
        debugPrint('Loaded customerId: $_customerId');
      }
    } catch (e) {
      debugPrint('Error loading customerId: $e');
    }
  }

  // Hàm hiển thị thông báo ở phía trên màn hình
  void _showSnackBar(String message, {bool isError = false}) {
    // Hủy bỏ thông báo hiện tại (nếu có)
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Tạo một Overlay để hiển thị thông báo ở phía trên
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).viewPadding.top + 10,
        left: 10,
        right: 10,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8),
          color: isError ? Colors.red : Colors.green,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
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
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
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
