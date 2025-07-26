import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import '../../../common/widgets/app_bar/app_bar.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Hỗ trợ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        backgroundColor: AppColors.primary,
        hideBack: false,
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.support_agent,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Chúng tôi sẵn sàng hỗ trợ bạn',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tìm hiểu cách sử dụng VaxPet hiệu quả nhất',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick Help Section
              _buildSectionTitle('Hỗ trợ nhanh'),
              const SizedBox(height: 16),
              _buildHelpItem(
                icon: Icons.pets,
                title: 'Quản lý thú cưng',
                subtitle: 'Hướng dẫn thêm và quản lý thông tin thú cưng',
                onTap: () => _showHelpDialog(context, 'Quản lý thú cưng', _getPetManagementHelp()),
              ),
              _buildHelpItem(
                icon: Icons.calendar_today,
                title: 'Lịch tiêm phòng',
                subtitle: 'Cách đặt lịch và theo dõi tiêm phòng',
                onTap: () => _showHelpDialog(context, 'Lịch tiêm phòng', _getVaccinationHelp()),
              ),
              _buildHelpItem(
                icon: Icons.location_on,
                title: 'Tìm phòng khám',
                subtitle: 'Hướng dẫn tìm kiếm phòng khám gần bạn',
                onTap: () => _showHelpDialog(context, 'Tìm phòng khám', _getClinicSearchHelp()),
              ),

              const SizedBox(height: 32),

              // FAQ Section
              _buildSectionTitle('Câu hỏi thường gặp'),
              const SizedBox(height: 16),
              _buildFAQExpansionTile(
                'Làm thế nào để thêm thú cưng mới?',
                'Vào mục "Thú cưng" trong menu chính, nhấn nút "+" ở góc phải màn hình. Điền đầy đủ thông tin về thú cưng của bạn và nhấn "Lưu".',
              ),
              _buildFAQExpansionTile(
                'Tôi có thể đặt lịch tiêm phòng như thế nào?',
                'Vào mục "Lịch tiêm", chọn thú cưng cần tiêm, chọn loại vaccine và thời gian phù hợp. Hệ thống sẽ tự động nhắc nhở bạn trước ngày hẹn.',
              ),
              _buildFAQExpansionTile(
                'Ứng dụng có miễn phí không?',
                'VaxPet hoàn toàn miễn phí cho các tính năng cơ bản như quản lý thú cưng và đặt lịch tiêm phòng.',
              ),
              _buildFAQExpansionTile(
                'Làm sao để sao lưu dữ liệu?',
                'Dữ liệu của bạn được tự động sao lưu trên cloud khi bạn đăng nhập tài khoản. Bạn có thể khôi phục dữ liệu khi đăng nhập trên thiết bị mới.',
              ),

              const SizedBox(height: 32),

              // Contact Section
              _buildSectionTitle('Liên hệ hỗ trợ'),
              const SizedBox(height: 16),
              _buildContactItem(
                icon: Icons.email,
                title: 'Email hỗ trợ',
                subtitle: 'support@vaxpet.com',
                onTap: () => _launchEmail('support@vaxpet.com'),
              ),
              _buildContactItem(
                icon: Icons.phone,
                title: 'Hotline',
                subtitle: '1900 1234',
                onTap: () => _launchPhone('19001234'),
              ),
              _buildContactItem(
                icon: Icons.schedule,
                title: 'Thời gian hỗ trợ',
                subtitle: 'T2 - CN: 8:00 - 17:00',
                onTap: null,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textBlack,
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppColors.textGray),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textGray),
        onTap: onTap,
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppColors.textGray),
        ),
        trailing: onTap != null ? Icon(Icons.open_in_new, size: 16, color: AppColors.textGray) : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildFAQExpansionTile(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: TextStyle(
                color: AppColors.textGray,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  String _getPetManagementHelp() {
    return '''
Để quản lý thú cưng hiệu quả:

1. Thêm thú cưng mới:
   • Nhấn nút "+" trong tab Thú cưng
   • Điền đầy đủ thông tin: tên, giống, tuổi, cân nặng
   • Thêm ảnh để dễ nhận biết

2. Cập nhật thông tin:
   • Chọn thú cưng cần chỉnh sửa
   • Nhấn "Chỉnh sửa" để cập nhật thông tin

3. Theo dõi sức khỏe:
   • Ghi chú tình trạng sức khỏe
   • Lưu lịch sử bệnh án
   • Đặt nhắc nhở khám định kỳ
    ''';
  }

  String _getVaccinationHelp() {
    return '''
Hướng dẫn sử dụng lịch tiêm phòng:

1. Đặt lịch tiêm mới:
   • Chọn thú cưng cần tiêm
   • Chọn loại vaccine phù hợp với độ tuổi
   • Chọn ngày giờ và phòng khám

2. Theo dõi lịch tiêm:
   • Xem lịch sử tiêm phòng
   • Nhận thông báo nhắc nhở
   • Cập nhật kết quả sau tiêm

3. Quản lý vaccine:
   • Theo dõi chu kỳ tiêm phòng
   • Xem danh sách vaccine cần thiết
   • Đặt lịch tiêm nhắc lại
    ''';
  }

  String _getClinicSearchHelp() {
    return '''
Tìm kiếm phòng khám thú y:

1. Sử dụng bản đồ:
   • Cho phép truy cập vị trí
   • Xem các phòng khám gần bạn
   • Xem thông tin chi tiết và đánh giá

2. Tìm kiếm theo địa chỉ:
   • Nhập địa chỉ cụ thể
   • Lọc theo khoảng cách
   • Sắp xếp theo đánh giá hoặc khoảng cách

3. Đặt lịch hẹn:
   • Chọn phòng khám phù hợp
   • Chọn thời gian có sẵn
   • Xác nhận thông tin đặt lịch
    ''';
  }

  String _getNotificationHelp() {
    return '''
Cài đặt thông báo:

1. Bật thông báo:
   • Vào Cài đặt > Thông báo
   • Cho phép ứng dụng gửi thông báo
   • Chọn loại thông báo muốn nhận

2. Tùy chỉnh thông báo:
   • Nhắc nhở tiêm phòng: 1-7 ngày trước
   • Nhắc nhở khám định kỳ
   • Thông báo từ phòng khám

3. Quản lý thông báo:
   • Xem lịch sử thông báo
   • Tắt/bật thông báo theo loại
   • Cài đặt âm thanh và rung
    ''';
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Hỗ trợ VaxPet',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}
