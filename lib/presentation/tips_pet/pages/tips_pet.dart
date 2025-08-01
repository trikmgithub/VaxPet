import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'tips_detail_page.dart';

class TipsPetPage extends StatelessWidget {
  final String petName;
  final int petId;
  final String? petBirthday;
  final String petSpecies;

  const TipsPetPage({
    super.key,
    required this.petName,
    required this.petId,
    this.petBirthday,
    required this.petSpecies
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Cẩm nang',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(context),
            _buildArticleGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      _getSpeciesIcon(),
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          petName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Loài: $petSpecies',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (petBirthday != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            'Sinh nhật: ${_formatBirthday(petBirthday!)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cẩm nang chăm sóc toàn diện',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatBirthday(String birthday) {
    try {
      // Thử parse với nhiều format khác nhau
      DateTime? dateTime;

      // Thử format yyyy-MM-dd
      if (birthday.contains('-') && birthday.split('-').length == 3) {
        try {
          dateTime = DateTime.parse(birthday);
        } catch (e) {
          // Nếu không parse được, thử format dd-MM-yyyy
          final parts = birthday.split('-');
          if (parts.length == 3) {
            dateTime = DateTime(
              int.parse(parts[2]), // year
              int.parse(parts[1]), // month
              int.parse(parts[0]), // day
            );
          }
        }
      }

      // Thử format dd/MM/yyyy
      if (dateTime == null && birthday.contains('/')) {
        final parts = birthday.split('/');
        if (parts.length == 3) {
          dateTime = DateTime(
            int.parse(parts[2]), // year
            int.parse(parts[1]), // month
            int.parse(parts[0]), // day
          );
        }
      }

      // Nếu parse thành công, format thành dd-MM-yyyy
      if (dateTime != null) {
        return DateFormat('dd-MM-yyyy').format(dateTime);
      }

      // Nếu không parse được, trả về string gốc
      return birthday;
    } catch (e) {
      // Nếu có lỗi, trả về string gốc
      return birthday;
    }
  }

  Widget _buildArticleGrid(BuildContext context) {
    final articles = _getArticles();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Featured article
          _buildFeaturedArticle(context, articles[0]),
          const SizedBox(height: 20),

          // Grid articles
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.85,
            ),
            itemCount: articles.length - 1,
            itemBuilder: (context, index) {
              return _buildArticleCard(context, articles[index + 1]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedArticle(BuildContext context, ArticleData article) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context, article),
      child: Container(
        height: 200,
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
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      article.color,
                      article.color.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'BÀI VIẾT NỔI BẬT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: article.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    article.icon,
                    color: article.color,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, ArticleData article) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context, article),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: article.color.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: article.color.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Icon(
                  article.icon,
                  size: 40,
                  color: article.color,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        article.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Đọc thêm',
                          style: TextStyle(
                            fontSize: 12,
                            color: article.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: article.color,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, ArticleData article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TipsDetailPage(
          article: article,
          petName: petName,
          petSpecies: petSpecies,
        ),
      ),
    );
  }

  IconData _getSpeciesIcon() {
    switch (petSpecies.toLowerCase()) {
      case 'chó':
      case 'dog':
        return Icons.pets;
      case 'mèo':
      case 'cat':
        return Icons.pets;
      case 'chim':
      case 'bird':
        return Icons.flutter_dash;
      case 'thỏ':
      case 'rabbit':
        return Icons.cruelty_free;
      default:
        return Icons.pets;
    }
  }

  List<ArticleData> _getArticles() {
    return [
      ArticleData(
        title: 'Hướng dẫn chăm sóc ${petSpecies.toLowerCase()}',
        subtitle: 'Những kiến thức cơ bản và nâng cao để chăm sóc ${petSpecies.toLowerCase()} một cách tốt nhất',
        icon: Icons.favorite,
        color: Colors.green,
        content: _getSpeciesSpecificTips(),
        type: 'species',
      ),
      ArticleData(
        title: 'Chuẩn bị trước tiêm phòng',
        subtitle: 'Những điều cần làm để đảm bảo an toàn khi tiêm phòng',
        icon: Icons.medical_services,
        color: Colors.orange,
        content: _getPreVaccinationTips(),
        type: 'pre_vaccination',
      ),
      ArticleData(
        title: 'Chăm sóc sau tiêm phòng',
        subtitle: 'Hướng dẫn theo dõi và chăm sóc sau khi tiêm phòng',
        icon: Icons.healing,
        color: Colors.red,
        content: _getPostVaccinationTips(),
        type: 'post_vaccination',
      ),
      ArticleData(
        title: 'Chăm sóc tổng quát',
        subtitle: 'Kiến thức tổng quan về chăm sóc sức khỏe thú cưng',
        icon: Icons.health_and_safety,
        color: Colors.purple,
        content: _getGeneralCareTips(),
        type: 'general',
      ),
    ];
  }

  List<String> _getSpeciesSpecificTips() {
    switch (petSpecies.toLowerCase()) {
      case 'chó':
      case 'dog':
        return [
          'Cho chó đi dạo ít nhất 30 phút mỗi ngày',
          'Tắm cho chó 1-2 lần/tuần tùy theo giống',
          'Chải lông hàng ngày để tránh rối lông',
          'Cho ăn 2-3 lần/ngày với khẩu phần phù hợp',
          'Huấn luyện cơ bản: ngồi, nằm, ở lại',
          'Kiểm tra tai, mắt, răng miệng thường xuyên',
          'Cắt móng chân 2-3 tuần/lần',
        ];
      case 'mèo':
      case 'cat':
        return [
          'Đặt khay cát sạch sẽ ở nơi yên tĩnh',
          'Thay cát vệ sinh hàng ngày',
          'Chải lông 2-3 lần/tuần để tránh búi lông',
          'Cho ăn thức ăn chất lượng cao 2 lần/ngày',
          'Cung cấp nước sạch thường xuyên',
          'Cắt móng vuốt 2-3 tuần/lần',
          'Tạo không gian riêng tư cho mèo nghỉ ngơi',
        ];
      case 'chim':
      case 'bird':
        return [
          'Vệ sinh lồng chim hàng ngày',
          'Cung cấp thức ăn hạt chất lượng cao',
          'Bổ sung rau xanh, trái cây tươi',
          'Đảm bảo ánh sáng tự nhiên 10-12 giờ/ngày',
          'Thay nước uống hàng ngày',
          'Kiểm tra sức khỏe qua hành vi và tiếng kêu',
          'Tạo môi trường kích thích trí tuệ',
        ];
      case 'thỏ':
      case 'rabbit':
        return [
          'Cung cấp cỏ khô (hay) không giới hạn',
          'Cho ăn rau xanh tươi hàng ngày',
          'Hạn chế pellet, chỉ 1/4 cốc/kg thể trọng',
          'Vệ sinh chuồng thỏ hàng ngày',
          'Để thỏ vận động ít nhất 3-4 giờ/ngày',
          'Kiểm tra răng và móng vuốt thường xuyên',
          'Chải lông đều đặn, đặc biệt khi thay lông',
        ];
      default:
        return [
          'Cho ăn đúng giờ, đủ dinh dưỡng',
          'Vệ sinh nơi ở sạch sẽ',
          'Quan sát sức khỏe hàng ngày',
          'Tạo môi trường sống phù hợp',
          'Thăm khám thú y định kỳ',
        ];
    }
  }

  List<String> _getPreVaccinationTips() {
    return [
      'Đảm bảo thú cưng khỏe mạnh trước khi tiêm',
      'Nhịn ăn 2-3 giờ trước khi tiêm (nếu bác sĩ yêu cầu)',
      'Mang theo sổ tiêm chủng và hồ sơ y tế',
      'Thông báo với bác sĩ về các triệu chứng bất thường',
      'Không tắm cho thú cưng 2-3 ngày trước tiêm',
      'Giữ thú cưng ở nơi yên tĩnh trước khi đến phòng khám',
      'Chuẩn bị câu hỏi để hỏi bác sĩ thú y',
      'Kiểm tra lịch tiêm chủng để đảm bảo đúng thời gian',
    ];
  }

  List<String> _getPostVaccinationTips() {
    return [
      'Quan sát thú cưng 24-48 giờ sau tiêm',
      'Để thú cưng nghỉ ngơi, tránh vận động mạnh',
      'Không tắm trong 7 ngày sau tiêm',
      'Cho ăn nhẹ nhàng, dễ tiêu hóa',
      'Theo dõi vùng tiêm có sưng, đỏ bất thường',
      'Liên hệ bác sĩ nếu xuất hiện: sốt cao, nôn mửa, tiêu chảy',
      'Ghi chép thời gian và phản ứng sau tiêm',
      'Đặt lịch tiêm mũi tiếp theo nếu cần',
      'Tránh tiếp xúc với động vật khác trong 1 tuần',
      'Cung cấp đủ nước, tránh stress',
    ];
  }

  List<String> _getGeneralCareTips() {
    return [
      'Thăm khám thú y định kỳ 6 tháng/lần',
      'Tiêm phòng đầy đủ theo lịch trình',
      'Tẩy giun định kỳ 3-6 tháng/lần',
      'Vệ sinh răng miệng thường xuyên',
      'Cân nặng thú cưng hàng tháng',
      'Tạo môi trường sống an toàn',
      'Chuẩn bị thuốc sơ cứu cơ bản',
      'Lưu số điện thoại bác sĩ thú y khẩn cấp',
      'Mua bảo hiểm thú cưng nếu có thể',
      'Tham gia cộng đồng yêu thú cưng để học hỏi',
    ];
  }
}

class ArticleData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<String> content;
  final String type;

  ArticleData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.content,
    required this.type,
  });
}
