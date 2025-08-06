import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../domain/tips_pet/entities/handbook.dart';
import '../bloc/tips_pet_cubit.dart';
import '../bloc/tips_pet_state.dart';
import 'tips_detail_page.dart';

class TipsPetPage extends StatefulWidget {
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
  State<TipsPetPage> createState() => _TipsPetPageState();
}

class _TipsPetPageState extends State<TipsPetPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late TipsPetCubit _cubit;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _cubit.loadMoreHandbooks();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _cubit = TipsPetCubit()..getAllHandbooks();
        return _cubit;
      },
      child: Scaffold(
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
        body: Column(
          children: [
            _buildHeaderSection(context),
            _buildSearchBar(),
            Expanded(
              child: BlocBuilder<TipsPetCubit, TipsPetState>(
                builder: (context, state) {
                  if (state is TipsPetLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TipsPetSuccess || state is TipsPetLoadingMore) {
                    final handbooks = state is TipsPetSuccess 
                        ? state.handbooks 
                        : (state as TipsPetLoadingMore).handbooks;
                    final hasReachedMax = state is TipsPetSuccess ? state.hasReachedMax : false;
                    
                    return _buildHandbooksList(context, handbooks, hasReachedMax);
                  } else if (state is TipsPetFailure) {
                    return _buildErrorWidget(context, state.message);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
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
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Cẩm nang chăm sóc toàn diện',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm cẩm nang...',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _cubit.refreshHandbooks();
                  },
                )
              : null,
        ),
        onChanged: (value) {
          setState(() {});
        },
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            _cubit.searchHandbooks(value.trim());
          } else {
            _cubit.refreshHandbooks();
          }
        },
      ),
    );
  }

  Widget _buildHandbooksList(BuildContext context, List<HandbookEntity> handbooks, bool hasReachedMax) {
    if (handbooks.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _cubit.refreshHandbooks(keyWord: _searchController.text.trim().isEmpty ? null : _searchController.text.trim()),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 200),
            Center(
              child: Text(
                'Chưa có cẩm nang nào',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _cubit.refreshHandbooks(keyWord: _searchController.text.trim().isEmpty ? null : _searchController.text.trim()),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        itemCount: _getItemCount(handbooks, hasReachedMax),
        itemBuilder: (context, index) {
          if (index == 0 && handbooks.isNotEmpty) {
            // Featured article (first item)
            return Column(
              children: [
                _buildFeaturedHandbook(context, handbooks[0]),
                const SizedBox(height: 20),
              ],
            );
          } else if (index < handbooks.length) {
            // Adjust index for grid items (skip featured article)
            final gridIndex = index - 1;
            if (gridIndex % 2 == 0 && gridIndex + 1 < handbooks.length - 1) {
              // Build row with 2 cards
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildHandbookCard(context, handbooks[gridIndex + 1], gridIndex + 1),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: gridIndex + 2 < handbooks.length
                          ? _buildHandbookCard(context, handbooks[gridIndex + 2], gridIndex + 2)
                          : const SizedBox(),
                    ),
                  ],
                ),
              );
            } else if (gridIndex % 2 == 1) {
              return const SizedBox.shrink(); // Skip odd indices as they're handled in pairs
            } else {
              // Single card for last item if odd number
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildHandbookCard(context, handbooks[gridIndex + 1], gridIndex + 1),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              );
            }
          } else {
            // Loading indicator or end message
            return _buildBottomWidget(hasReachedMax);
          }
        },
      ),
    );
  }

  int _getItemCount(List<HandbookEntity> handbooks, bool hasReachedMax) {
    if (handbooks.isEmpty) return 0;
    // Featured item + grid items + bottom widget
    final gridItemCount = handbooks.length > 1 ? ((handbooks.length - 1) / 2).ceil() : 0;
    return 1 + gridItemCount + 1; // 1 for featured + grid + 1 for bottom
  }

  Widget _buildBottomWidget(bool hasReachedMax) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: hasReachedMax
            ? Column(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green[400],
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Đã hiển thị tất cả cẩm nang',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildFeaturedHandbook(BuildContext context, HandbookEntity handbook) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context, handbook),
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
                      _getHandbookColor(0),
                      _getHandbookColor(0).withValues(alpha: 0.8),
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
                          color: _getHandbookColor(0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      handbook.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      handbook.introduction,
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
                    _getHandbookIcon(0),
                    color: _getHandbookColor(0),
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

  Widget _buildHandbookCard(BuildContext context, HandbookEntity handbook, int index) {
    final color = _getHandbookColor(index);
    final icon = _getHandbookIcon(index);

    return GestureDetector(
      onTap: () => _navigateToDetail(context, handbook),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
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
                color: color.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
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
                      handbook.title,
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
                        handbook.introduction,
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
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: color,
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

  Widget _buildErrorWidget(BuildContext context, String message) {
    return RefreshIndicator(
      onRefresh: () => _cubit.refreshHandbooks(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Có lỗi xảy ra',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _cubit.refreshHandbooks();
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, HandbookEntity handbook) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TipsDetailPage(
          handbook: handbook,
          petName: widget.petName,
          petSpecies: widget.petSpecies,
        ),
      ),
    );
  }

  String _formatBirthday(String birthday) {
    try {
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

  IconData _getSpeciesIcon() {
    switch (widget.petSpecies.toLowerCase()) {
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

  Color _getHandbookColor(int index) {
    final colors = [
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.blue,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  IconData _getHandbookIcon(int index) {
    final icons = [
      Icons.favorite,
      Icons.medical_services,
      Icons.healing,
      Icons.health_and_safety,
      Icons.pets,
      Icons.info,
    ];
    return icons[index % icons.length];
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
