import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/support_cubit.dart';
import '../bloc/support_state.dart';

class SupportWidget extends StatefulWidget {
  const SupportWidget({super.key});

  @override
  State<SupportWidget> createState() => _SupportWidgetState();
}

class _SupportWidgetState extends State<SupportWidget> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _currentSearchText = '';

  @override
  void initState() {
    super.initState();
    context.read<SupportCubit>().getSupports();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _currentSearchText = _searchController.text;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<SupportCubit>().loadMoreSupports(keyword: _searchController.text.isEmpty ? null : _searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Column(
      children: [
        // Search Bar with responsive padding
        Container(
          padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 600 : double.infinity,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm danh mục hỗ trợ...',
                hintStyle: TextStyle(
                  color: AppColors.textGray.withOpacity(0.7),
                  fontSize: isTablet ? 16 : 14,
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.search_rounded,
                    color: AppColors.primary,
                    size: isTablet ? 24 : 20,
                  ),
                ),
                suffixIcon: _currentSearchText.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: AppColors.textGray,
                          size: isTablet ? 24 : 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          context.read<SupportCubit>().getSupports();
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.primary.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 20 : 16,
                  vertical: isTablet ? 16 : 12,
                ),
              ),
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: AppColors.textBlack,
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  context.read<SupportCubit>().searchSupports(value.trim());
                } else {
                  context.read<SupportCubit>().getSupports();
                }
              },
            ),
          ),
        ),

        // Support List
        Expanded(
          child: BlocBuilder<SupportCubit, SupportState>(
            builder: (context, state) {
              if (state is SupportLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Đang tải danh mục hỗ trợ...',
                        style: TextStyle(
                          color: AppColors.textGray,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is SupportError) {
                return Center(
                  child: Container(
                    margin: EdgeInsets.all(isTablet ? 32 : 24),
                    padding: EdgeInsets.all(isTablet ? 32 : 24),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: isTablet ? 80 : 64,
                          color: Colors.red.withOpacity(0.7),
                        ),
                        SizedBox(height: isTablet ? 20 : 16),
                        Text(
                          'Có lỗi xảy ra',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: isTablet ? 20 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isTablet ? 12 : 8),
                        Text(
                          state.message,
                          style: TextStyle(
                            color: AppColors.textGray,
                            fontSize: isTablet ? 16 : 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isTablet ? 24 : 20),
                        ElevatedButton.icon(
                          onPressed: () => context.read<SupportCubit>().getSupports(),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Thử lại'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 32 : 24,
                              vertical: isTablet ? 16 : 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is SupportLoaded) {
                if (state.supports.isEmpty) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.all(isTablet ? 32 : 24),
                      padding: EdgeInsets.all(isTablet ? 32 : 24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.support_agent_rounded,
                            size: isTablet ? 80 : 64,
                            color: AppColors.primary.withOpacity(0.7),
                          ),
                          SizedBox(height: isTablet ? 20 : 16),
                          Text(
                            'Không tìm thấy danh mục hỗ trợ',
                            style: TextStyle(
                              color: AppColors.textBlack,
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: isTablet ? 12 : 8),
                          Text(
                            _currentSearchText.isNotEmpty
                                ? 'Thử tìm kiếm với từ khóa khác'
                                : 'Chưa có danh mục hỗ trợ nào',
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontSize: isTablet ? 16 : 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    if (_currentSearchText.trim().isNotEmpty) {
                      await context.read<SupportCubit>().searchSupports(_currentSearchText.trim());
                    } else {
                      await context.read<SupportCubit>().getSupports();
                    }
                  },
                  color: AppColors.primary,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 16,
                      vertical: isTablet ? 16 : 12,
                    ),
                    itemCount: state.supports.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.supports.length) {
                        return Container(
                          padding: EdgeInsets.all(isTablet ? 24 : 16),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            strokeWidth: 2,
                          ),
                        );
                      }

                      final support = state.supports[index];
                      return _buildSupportItem(support, isTablet);
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSupportItem(dynamic support, bool isTablet) {
    // Extract support data safely
    String title = 'Không có tiêu đề';
    String description = '';
    String content = '';
    String supportId = '';

    if (support != null && support is Map) {
      title = support['title']?.toString() ??
              support['Title']?.toString() ??
              'Không có tiêu đề';

      description = support['description']?.toString() ??
                    support['Description']?.toString() ??
                    '';

      content = support['content']?.toString() ??
                support['Content']?.toString() ??
                '';

      supportId = support['supportCategoryId']?.toString() ??
                  support['SupportCategoryId']?.toString() ??
                  support['id']?.toString() ??
                  '';
    }

    return Container(
      margin: EdgeInsets.only(
        bottom: isTablet ? 16 : 12,
      ),
      constraints: BoxConstraints(
        maxWidth: isTablet ? 800 : double.infinity,
      ),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            key: ValueKey(supportId.isNotEmpty ? supportId : UniqueKey().toString()),
            tilePadding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24 : 20,
              vertical: isTablet ? 16 : 12,
            ),
            childrenPadding: EdgeInsets.zero,
            leading: Container(
              padding: EdgeInsets.all(isTablet ? 12 : 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.8),
                    AppColors.primary.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: isTablet ? 24 : 20,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
                fontSize: isTablet ? 18 : 16,
                height: 1.3,
              ),
            ),
            subtitle: description.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: isTablet ? 8 : 6),
                    child: Text(
                      description,
                      style: TextStyle(
                        color: AppColors.textGray,
                        fontSize: isTablet ? 14 : 12,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : null,
            iconColor: AppColors.primary,
            collapsedIconColor: AppColors.primary,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 20,
                ),
                child: Column(
                  children: [
                    if (description.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(isTablet ? 20 : 16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.blue,
                                  size: isTablet ? 20 : 18,
                                ),
                                SizedBox(width: isTablet ? 12 : 8),
                                Text(
                                  'Mô tả',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: isTablet ? 16 : 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isTablet ? 12 : 10),
                            Text(
                              description,
                              style: TextStyle(
                                color: AppColors.textGray,
                                height: 1.6,
                                fontSize: isTablet ? 15 : 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (content.isNotEmpty) SizedBox(height: isTablet ? 16 : 12),
                    ],
                    if (content.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(isTablet ? 20 : 16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.article_outlined,
                                  color: AppColors.primary,
                                  size: isTablet ? 20 : 18,
                                ),
                                SizedBox(width: isTablet ? 12 : 8),
                                Text(
                                  'Nội dung chi tiết',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: isTablet ? 16 : 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isTablet ? 12 : 10),
                            Text(
                              content,
                              style: TextStyle(
                                color: AppColors.textGray,
                                height: 1.6,
                                fontSize: isTablet ? 15 : 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: isTablet ? 20 : 16),
            ],
          ),
        ),
      ),
    );
  }
}
