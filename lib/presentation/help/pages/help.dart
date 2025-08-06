import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../bloc/faq_cubit.dart';
import '../bloc/support_cubit.dart';
import '../widgets/faq_widget.dart';
import '../widgets/support_widget.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FAQCubit()),
        BlocProvider(create: (context) => SupportCubit()),
      ],
      child: Scaffold(
        body: Column(
          children: [
            // Custom header với style giống BasicAppbar
            _buildCustomHeader(context, isTablet),

            // TabBar content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  FAQWidget(),
                  SupportWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // AppBar section
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Custom back button giống BasicAppbar
                      _buildBackButton(context, isTablet),

                      // Title
                      Expanded(
                        child: Center(
                          child: Text(
                            'Hỗ trợ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textWhite,
                              fontSize: isTablet ? 22 : 20,
                            ),
                          ),
                        ),
                      ),

                      // Spacer để cân bằng với back button
                      SizedBox(width: isTablet ? 48 : 44),
                    ],
                  ),
                ),

                // TabBar section
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: isTablet ? 32 : 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 24 : 16,
                            vertical: isTablet ? 12 : 10,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.help_outline_rounded,
                                size: isTablet ? 20 : 18,
                              ),
                              SizedBox(width: isTablet ? 8 : 6),
                              Text(
                                'FAQ',
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 24 : 16,
                            vertical: isTablet ? 12 : 10,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.support_agent_rounded,
                                size: isTablet ? 20 : 18,
                              ),
                              SizedBox(width: isTablet ? 8 : 6),
                              Text(
                                'Kênh liên hệ',
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    labelColor: AppColors.textWhite,
                    unselectedLabelColor: AppColors.textWhite.withOpacity(0.7),
                    indicator: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, bool isTablet) {
    final size = isTablet ? 44.0 : 40.0;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: AppColors.returnBackground,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: isTablet ? 18 : 16,
            color: AppColors.returnIcon,
          ),
        ),
      ),
    );
  }
}
