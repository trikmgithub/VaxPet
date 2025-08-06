import 'package:flutter/material.dart';
import '../../../domain/tips_pet/entities/handbook.dart';

class TipsDetailPage extends StatelessWidget {
  final HandbookEntity handbook;
  final String petName;
  final String petSpecies;

  const TipsDetailPage({
    super.key,
    required this.handbook,
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
    final color = _getColorFromTitle(handbook.title);

    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: color,
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
                color,
                color.withValues(alpha: 0.7),
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
                            _getIconFromTitle(handbook.title),
                            size: 16,
                            color: color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'CẨM NANG',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      handbook.title,
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

        // Important note
        if (handbook.importantNote.isNotEmpty)
          _buildImportantNote(),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildIntroductionCard() {
    final color = _getColorFromTitle(handbook.title);

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
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: color,
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
            handbook.introduction,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          if (handbook.highlight.isNotEmpty) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: color.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: color,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      handbook.highlight,
                      style: TextStyle(
                        fontSize: 14,
                        color: color.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    final color = _getColorFromTitle(handbook.title);
    final contentItems = _parseContentItems(handbook.content);

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
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getIconFromTitle(handbook.title),
                  color: color,
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
          if (contentItems.isNotEmpty)
            ...contentItems.asMap().entries.map((entry) {
              int index = entry.key;
              String item = entry.value;
              return _buildContentItem(item, index + 1, color);
            }).toList()
          else
            Text(
              handbook.content,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContentItem(String content, int number, Color color) {
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
              color: color,
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
              content.trim(),
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

  Widget _buildImportantNote() {
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
                  Icons.warning_amber_outlined,
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
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.amber.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              handbook.importantNote,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }


  ImageProvider _getBackgroundPattern() {
    // You can replace this with actual pattern images
    return const AssetImage('assets/images/pattern.png');
  }

  Color _getColorFromTitle(String title) {
    if (title.toLowerCase().contains('tiêm phòng') || title.toLowerCase().contains('vaccine')) {
      if (title.toLowerCase().contains('trước') || title.toLowerCase().contains('chuẩn bị')) {
        return Colors.orange;
      } else if (title.toLowerCase().contains('sau')) {
        return Colors.red;
      }
      return Colors.blue;
    } else if (title.toLowerCase().contains('chăm sóc')) {
      return Colors.green;
    } else if (title.toLowerCase().contains('tổng quát')) {
      return Colors.purple;
    }
    return Colors.teal;
  }

  IconData _getIconFromTitle(String title) {
    if (title.toLowerCase().contains('tiêm phòng') || title.toLowerCase().contains('vaccine')) {
      if (title.toLowerCase().contains('trước') || title.toLowerCase().contains('chuẩn bị')) {
        return Icons.medical_services;
      } else if (title.toLowerCase().contains('sau')) {
        return Icons.healing;
      }
      return Icons.vaccines;
    } else if (title.toLowerCase().contains('chăm sóc')) {
      return Icons.favorite;
    } else if (title.toLowerCase().contains('tổng quát')) {
      return Icons.health_and_safety;
    }
    return Icons.info;
  }

  List<String> _parseContentItems(String content) {
    // Try to split content by common separators
    if (content.contains('  ')) {
      return content.split('  ').where((item) => item.trim().isNotEmpty).toList();
    } else if (content.contains('\n')) {
      return content.split('\n').where((item) => item.trim().isNotEmpty).toList();
    } else if (content.contains('. ')) {
      final items = content.split('. ');
      return items.map((item) => item.trim().endsWith('.') ? item : '$item.').toList();
    }
    return [];
  }
}
