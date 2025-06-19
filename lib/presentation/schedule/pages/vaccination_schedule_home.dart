import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:vaxpet/data/schedule/models/create_app_vac_req_params.dart';
import 'package:vaxpet/domain/schedule/usecases/create_app_vac.dart';
import 'package:vaxpet/service_locator.dart';

import '../../../common/widgets/back_button/back_button.dart';
import '../../../common/widgets/reactive_button/reactive_button.dart';
import '../../pet/widgets/category_text.dart';

class VaccinationScheduleHomePage extends StatefulWidget {
  final String petName;
  final int petId;
  const VaccinationScheduleHomePage({
    super.key,
    required this.petName,
    required this.petId,
  });

  @override
  State<VaccinationScheduleHomePage> createState() => _VaccinationScheduleHomePageState();
}

class _VaccinationScheduleHomePageState extends State<VaccinationScheduleHomePage> {
  final TextEditingController _dateOfSheduleController = TextEditingController();
  final createAppVacUseCase = sl<CreateAppVacUseCase>();
  int? _customerId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCustomerId();
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

  // Hàm hiển thị SnackBar
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // Phương thức tạo lịch hẹn tiêm vắc-xin
  Future<void> _createVaccinationSchedule() async {
    if (_customerId == null) {
      _showSnackBar('Không tìm thấy thông tin người dùng', isError: true);
      return;
    }

    if (_dateOfSheduleController.text.isEmpty) {
      _showSnackBar('Vui lòng chọn ngày hẹn', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Chuyển đổi định dạng ngày từ dd/MM/yyyy sang yyyy-MM-ddTHH:mm:ss.SSSZ
      final selectedDate = DateFormat('dd/MM/yyyy').parse(_dateOfSheduleController.text);
      final formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(selectedDate);

      final params = CreateAppVacReqParams(
        customerId: _customerId!,
        petId: widget.petId,
        appointmentDate: formattedDate,
        serviceType: 1, // 1 cho dịch vụ tiêm vắc-xin
        location: 1,    // 1 cho dịch vụ tại nhà
        address: "Địa chỉ mặc định",
        diseaseId: 1,   // ID của bệnh cần tiêm vắc-xin
      );

      final result = await createAppVacUseCase(params: params);

      result.fold(
        (error) {
          _showSnackBar('Lỗi: $error', isError: true);
        },
        (data) {
          _showSnackBar('Đặt lịch thành công');
          // Quay lại trang trước sau khi đặt lịch thành công
          Navigator.pop(context);
        }
      );
    } catch (e) {
      _showSnackBar('Đã xảy ra lỗi: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
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
            const SizedBox(height: 24),
            ReactiveButton(
              onPressed: () async => await _createVaccinationSchedule(),
              title: 'Đặt lịch',
              onSuccess: () {},
              onFailure: (error) {
                _showSnackBar(error, isError: true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateOfSchedule(BuildContext context) {
    return TextFormField(
      controller: _dateOfSheduleController,
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
          _dateOfSheduleController.text = formattedDate;
        }
      },
    );
  }
}
