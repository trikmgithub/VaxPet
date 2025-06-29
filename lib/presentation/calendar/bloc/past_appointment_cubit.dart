import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaxpet/domain/appointment/entities/past_appointment.dart';
import 'package:vaxpet/domain/appointment/usecases/get_past_appointment_by_cusid.dart';
import 'package:vaxpet/presentation/calendar/bloc/past_appointment_state.dart';
import 'package:vaxpet/service_locator.dart';

class PastAppointmentCubit extends Cubit<PastAppointmentState> {
  PastAppointmentCubit() : super(PastAppointmentLoading());

  // Thêm các thuộc tính để quản lý pagination
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMoreData = true;
  List<PastAppointmentEntity> _allAppointments = [];

  // Getter cho các thuộc tính
  int get currentPage => _currentPage;
  bool get hasMoreData => _hasMoreData;

  // Phương thức khởi tạo để lấy dữ liệu đầu tiên
  void getPastAppointments() async {
    try {
      // Reset state khi gọi lại từ đầu
      _currentPage = 1;
      _hasMoreData = true;
      _allAppointments = [];

      emit(PastAppointmentLoading());

      // Get customer_profile ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('customerId');

      if (customerId == null) {
        emit(PastAppointmentError(message: 'Customer ID not found'));
        return;
      }

      // Truyền một đối tượng có các thuộc tính cần thiết
      var returnedData = await sl<GetPastAppointmentByCusId>().call(
        params: _PastAppointmentParams(
          customerId: customerId,
          pageNumber: _currentPage,
          pageSize: _pageSize,
        ),
      );

      returnedData.fold(
        (error) => emit(PastAppointmentError(message: error.toString())),
        (appointments) {
          _allAppointments = appointments;

          // Nếu số lượng kết quả nhỏ hơn page size, đã hết dữ liệu
          if (appointments.length < _pageSize) {
            _hasMoreData = false;
          }

          emit(PastAppointmentLoaded(
            appointments: _allAppointments,
            hasMoreData: _hasMoreData,
            currentPage: _currentPage,
          ));
        },
      );
    } catch (e) {
      emit(PastAppointmentError(message: e.toString()));
    }
  }

  // Phương thức để tải thêm dữ liệu cho trang tiếp theo
  void loadMoreAppointments() async {
    // Nếu không còn dữ liệu hoặc đang tải, không làm gì
    if (!_hasMoreData || state is PastAppointmentLoading) {
      return;
    }

    try {
      emit(PastAppointmentLoadingMore(
        appointments: _allAppointments,
        currentPage: _currentPage,
      ));

      // Tăng số trang lên 1
      _currentPage++;

      // Get customer_profile ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('customerId');

      if (customerId == null) {
        emit(PastAppointmentError(message: 'Customer ID not found'));
        return;
      }

      // Truyền một đối tượng có các thuộc tính cần thiết
      var returnedData = await sl<GetPastAppointmentByCusId>().call(
        params: _PastAppointmentParams(
          customerId: customerId,
          pageNumber: _currentPage,
          pageSize: _pageSize,
        ),
      );

      returnedData.fold(
        (error) => emit(PastAppointmentError(message: error.toString())),
        (newAppointments) {
          // Nếu không có dữ liệu mới, đã hết dữ liệu
          if (newAppointments.isEmpty) {
            _hasMoreData = false;
            emit(PastAppointmentLoaded(
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

          emit(PastAppointmentLoaded(
            appointments: _allAppointments,
            hasMoreData: _hasMoreData,
            currentPage: _currentPage,
          ));
        },
      );
    } catch (e) {
      emit(PastAppointmentError(message: e.toString()));
    }
  }

  // Phương thức để làm mới dữ liệu
  void refreshAppointments() {
    getPastAppointments();
  }
}

// Lớp giúp đóng gói các tham số
class _PastAppointmentParams {
  final int customerId;
  final int pageNumber;
  final int pageSize;

  _PastAppointmentParams({
    required this.customerId,
    required this.pageNumber,
    required this.pageSize,
  });
}
