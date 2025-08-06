import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/faq_cubit.dart';
import '../bloc/faq_state.dart';

class FAQWidget extends StatefulWidget {
  const FAQWidget({super.key});

  @override
  State<FAQWidget> createState() => _FAQWidgetState();
}

class _FAQWidgetState extends State<FAQWidget> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _currentSearchText = '';

  @override
  void initState() {
    super.initState();
    context.read<FAQCubit>().getFAQs();
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
      context.read<FAQCubit>().loadMoreFAQs(keyword: _searchController.text.isEmpty ? null : _searchController.text);
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
                hintText: 'Tìm kiếm câu hỏi thường gặp...',
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
                          context.read<FAQCubit>().getFAQs();
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
                  context.read<FAQCubit>().searchFAQs(value.trim());
                } else {
                  context.read<FAQCubit>().getFAQs();
                }
              },
            ),
          ),
        ),

        // FAQ List
        Expanded(
          child: BlocBuilder<FAQCubit, FAQState>(
            builder: (context, state) {
              if (state is FAQLoading) {
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
                        'Đang tải câu hỏi...',
                        style: TextStyle(
                          color: AppColors.textGray,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is FAQError) {
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
                          onPressed: () => context.read<FAQCubit>().getFAQs(),
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

              if (state is FAQLoaded) {
                if (state.faqs.isEmpty) {
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
                            Icons.help_outline_rounded,
                            size: isTablet ? 80 : 64,
                            color: AppColors.primary.withOpacity(0.7),
                          ),
                          SizedBox(height: isTablet ? 20 : 16),
                          Text(
                            'Không tìm thấy câu hỏi',
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
                                : 'Chưa có câu hỏi nào được thêm',
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
                      await context.read<FAQCubit>().searchFAQs(_currentSearchText.trim());
                    } else {
                      await context.read<FAQCubit>().getFAQs();
                    }
                  },
                  color: AppColors.primary,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 16,
                      vertical: isTablet ? 16 : 12,
                    ),
                    itemCount: state.faqs.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.faqs.length) {
                        return Container(
                          padding: EdgeInsets.all(isTablet ? 24 : 16),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            strokeWidth: 2,
                          ),
                        );
                      }

                      final faq = state.faqs[index];
                      return _buildFAQItem(faq, isTablet);
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

  Widget _buildFAQItem(dynamic faq, bool isTablet) {
    // More robust data extraction
    String question = 'Không có câu hỏi';
    String answer = 'Không có câu trả lời';
    String faqId = '';

    if (faq != null) {
      if (faq is Map) {
        question = faq['question']?.toString() ??
                   faq['Question']?.toString() ??
                   'Không có câu hỏi';

        answer = faq['answer']?.toString() ??
                 faq['Answer']?.toString() ??
                 'Không có câu trả lời';

        faqId = faq['faqItemId']?.toString() ??
                faq['FaqItemId']?.toString() ??
                faq['id']?.toString() ??
                '';
      }
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
            key: ValueKey(faqId.isNotEmpty ? faqId : UniqueKey().toString()),
            tilePadding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24 : 20,
              vertical: isTablet ? 16 : 12,
            ),
            childrenPadding: EdgeInsets.zero,
            leading: Container(
              padding: EdgeInsets.all(isTablet ? 12 : 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.help_outline_rounded,
                color: AppColors.primary,
                size: isTablet ? 24 : 20,
              ),
            ),
            title: Text(
              question,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
                fontSize: isTablet ? 18 : 16,
                height: 1.3,
              ),
            ),
            iconColor: AppColors.primary,
            collapsedIconColor: AppColors.primary,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 20,
                ),
                padding: EdgeInsets.all(isTablet ? 24 : 20),
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
                          Icons.lightbulb_outline_rounded,
                          color: AppColors.primary,
                          size: isTablet ? 20 : 18,
                        ),
                        SizedBox(width: isTablet ? 12 : 8),
                        Text(
                          'Câu trả lời',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    Text(
                      answer,
                      style: TextStyle(
                        color: AppColors.textGray,
                        height: 1.6,
                        fontSize: isTablet ? 16 : 14,
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
