import 'package:flutter/material.dart';
import 'tips_pet.dart';

class TipsDetailPage extends StatelessWidget {
  final ArticleData article;
  final String petName;
  final String petSpecies;

  const TipsDetailPage({
    super.key,
    required this.article,
    required this.petName,
    required this.petSpecies,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: article.color,
      foregroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                article.color,
                article.color.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: Opacity(
                  opacity: 0.1,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _getBackgroundPattern(),
                        repeat: ImageRepeat.repeat,
                        scale: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 60,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            article.icon,
                            size: 16,
                            color: article.color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _getCategoryText(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: article.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dành cho $petName ($petSpecies)',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Introduction card
        _buildIntroductionCard(),

        // Main content
        _buildMainContent(),

        // Additional tips based on article type
        _buildAdditionalTips(),

        // Bottom action
        _buildBottomAction(context),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildIntroductionCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: article.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: article.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Giới thiệu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            article.subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: article.color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: article.color.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: article.color,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _getIntroductionTip(),
                    style: TextStyle(
                      fontSize: 14,
                      color: article.color.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: article.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  article.icon,
                  color: article.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Hướng dẫn chi tiết',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...article.content.asMap().entries.map((entry) {
            int index = entry.key;
            String tip = entry.value;
            return _buildTipItem(tip, index + 1);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip, int number) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: article.color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalTips() {
    List<String> additionalTips = _getAdditionalTips();

    if (additionalTips.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.star_outline,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Lưu ý quan trọng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...additionalTips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tip,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            article.color.withValues(alpha: 0.1),
            article.color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: article.color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.favorite,
            color: article.color,
            size: 30,
          ),
          const SizedBox(height: 10),
          const Text(
            'Bài viết hữu ích?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy chia sẻ với những người yêu thú cưng khác!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cảm ơn bạn đã đánh giá!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.thumb_up),
                  label: const Text('Hữu ích'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: article.color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tính năng chia sẻ sẽ sớm có!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Chia sẻ'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: article.color,
                    side: BorderSide(color: article.color),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ImageProvider _getBackgroundPattern() {
    // You can replace this with actual pattern images
    return const AssetImage('assets/images/pattern.png');
  }

  String _getCategoryText() {
    switch (article.type) {
      case 'species':
        return 'CHĂM SÓC THEO LOÀI';
      case 'pre_vaccination':
        return 'TRƯỚC TIÊM PHÒNG';
      case 'post_vaccination':
        return 'SAU TIÊM PHÒNG';
      case 'general':
        return 'CHĂM SÓC TỔNG QUÁT';
      default:
        return 'CẨM NANG';
    }
  }

  String _getIntroductionTip() {
    switch (article.type) {
      case 'species':
        return 'Mỗi loài thú cưng có nhu cầu chăm sóc khác nhau. Hãy tìm hiểu kỹ về loài của bạn!';
      case 'pre_vaccination':
        return 'Chuẩn bị kỹ càng trước tiêm phòng giúp giảm thiểu rủi ro và tăng hiệu quả vắc-xin.';
      case 'post_vaccination':
        return 'Theo dõi sát sao thú cưng sau tiêm phòng để phát hiện sớm các phản ứng bất thường.';
      case 'general':
        return 'Chăm sóc định kỳ và đúng cách là chìa khóa để thú cưng luôn khỏe mạnh.';
      default:
        return 'Hãy đọc kỹ và áp dụng những lời khuyên phù hợp với thú cưng của bạn.';
    }
  }

  List<String> _getAdditionalTips() {
    switch (article.type) {
      case 'species':
        return [
          'Luôn tham khảo ý kiến bác sĩ thú y khi có thắc mắc',
          'Mỗi cá thể có thể có nhu cầu khác nhau dù cùng loài',
          'Quan sát hành vi hàng ngày để hiểu rõ thú cưng hơn',
        ];
      case 'pre_vaccination':
        return [
          'Không tiêm phòng khi thú cưng bị bệnh hoặc stress',
          'Thông báo với bác sĩ về các loại thuốc đang sử dụng',
          'Đến đúng giờ hẹn để tránh chờ đợi lâu',
        ];
      case 'post_vaccination':
        return [
          'Gọi ngay cho bác sĩ nếu thú cưng có phản ứng nghiêm trọng',
          'Ghi chép chi tiết về tình trạng thú cưng',
          'Không lo lắng với các phản ứng nhẹ như buồn ngủ',
        ];
      case 'general':
        return [
          'Tạo lập thói quen chăm sóc đều đặn',
          'Đầu tư vào thức ăn và đồ dùng chất lượng',
          'Tham gia các khóa học chăm sóc thú cưng',
        ];
      default:
        return [];
    }
  }
}
