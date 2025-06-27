import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaxpet/service_locator.dart';

import '../../../domain/appointment/entities/future_appointment.dart';
import '../../../domain/appointment/usecases/get_future_appointment_by_cusid.dart';
import 'future_appointment_state.dart';

class FutureAppointmentCubit extends Cubit<FutureAppointmentState> {
  FutureAppointmentCubit() : super(FutureAppointmentLoading());

  // Thêm các thuộc tính để quản lý pagination
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMoreData = true;
  List<FutureAppointmentEntity> _allAppointments = [];

  // Getter cho các thuộc tính
  int get currentPage => _currentPage;
  bool get hasMoreData => _hasMoreData;

  // Phương thức khởi tạo để lấy dữ liệu đầu tiên
  void getFutureAppointments() async {
    try {
      // Reset state khi gọi lại từ đầu
      _currentPage = 1;
      _hasMoreData = true;
      _allAppointments = [];

      emit(FutureAppointmentLoading());

      // Get customer ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('customerId');

      if (customerId == null) {
        emit(FutureAppointmentError(message: 'Customer ID not found'));
        return;
      }

      // Truyền một đối tượng có các thuộc tính cần thiết
      var returnedData = await sl<GetFutureAppointmentByCusId>().call(
        params: _FutureAppointmentParams(
          customerId: customerId,
          pageNumber: _currentPage,
          pageSize: _pageSize,
        ),
      );

      returnedData.fold(
            (error) => emit(FutureAppointmentError(message: error.toString())),
            (appointments) {
          _allAppointments = appointments;

          // Nếu số lượng kết quả nhỏ hơn page size, đã hết dữ liệu
          if (appointments.length < _pageSize) {
            _hasMoreData = false;
          }

          emit(FutureAppointmentLoaded(
            appointments: _allAppointments,
            hasMoreData: _hasMoreData,
            currentPage: _currentPage,
          ));
        },
      );
    } catch (e) {
      emit(FutureAppointmentError(message: e.toString()));
    }
  }

  // Phương thức để tải thêm dữ liệu cho trang tiếp theo
  void loadMoreAppointments() async {
    // Nếu không còn dữ liệu hoặc đang tải, không làm gì
    if (!_hasMoreData || state is FutureAppointmentLoading) {
      return;
    }

    try {
      emit(FutureAppointmentLoadingMore(
        appointments: _allAppointments,
        currentPage: _currentPage,
      ));

      // Tăng số trang lên 1
      _currentPage++;

      // Get customer ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('customerId');

      if (customerId == null) {
        emit(FutureAppointmentError(message: 'Customer ID not found'));
        return;
      }

      // Truyền một đối tượng có các thuộc tính cần thiết
      var returnedData = await sl<GetFutureAppointmentByCusId>().call(
        params: _FutureAppointmentParams(
          customerId: customerId,
          pageNumber: _currentPage,
          pageSize: _pageSize,
        ),
      );

      returnedData.fold(
            (error) => emit(FutureAppointmentError(message: error.toString())),
            (newAppointments) {
          // Nếu không có dữ liệu mới, đã hết dữ liệu
          if (newAppointments.isEmpty) {
            _hasMoreData = false;
            emit(FutureAppointmentLoaded(
              appointments: _allAppointments,
              hasMoreData: _hasMoreData,
              currentPage: _currentPage - 1, // Giảm trang lại vì không có dữ liệu
            ));
            return;
          }

          // Thêm các cuộc hẹn mới vào danh sách hiện tại
          _allAppointments.addAll(newAppointments);

          // Nếu số lượng kết quả nhỏ hơn page size, đã hết dữ liệu
          if (newAppointments.length < _pageSize) {
            _hasMoreData = false;
          }

          emit(FutureAppointmentLoaded(
            appointments: _allAppointments,
            hasMoreData: _hasMoreData,
            currentPage: _currentPage,
          ));
        },
      );
    } catch (e) {
      emit(FutureAppointmentError(message: e.toString()));
    }
  }

  // Phương thức để làm mới dữ liệu
  void refreshAppointments() {
    getFutureAppointments();
  }
}

// Lớp giúp đóng gói các tham số
class _FutureAppointmentParams {
  final int customerId;
  final int pageNumber;
  final int pageSize;

  _FutureAppointmentParams({
    required this.customerId,
    required this.pageNumber,
    required this.pageSize,
  });
}
