import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import '../../../common/widgets/back_button/back_button.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../auth/pages/register.dart';
import '../../auth/pages/signin.dart';

class RegisterSigninPage extends StatefulWidget {
  const RegisterSigninPage({super.key});

  @override
  State<RegisterSigninPage> createState() => _RegisterSigninPageState();
}

class _RegisterSigninPageState extends State<RegisterSigninPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isMediumScreen = screenSize.width >= 360 && screenSize.width < 600;
    final isLargeScreen = screenSize.width >= 600;

    // Responsive sizing
    final buttonWidth =
        isSmallScreen ? 130.0 : (isMediumScreen ? 150.0 : 180.0);
    final buttonHeight = isSmallScreen ? 46.0 : 50.0;
    final topPadding = isSmallScreen ? 16.0 : (isMediumScreen ? 20.0 : 24.0);
    final horizontalPadding =
        isSmallScreen ? 16.0 : (isMediumScreen ? 24.0 : 32.0);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF5F9FF), Color(0xFFEDF5FF)],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Main content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    // Top section with back button and spacing
                    SizedBox(height: topPadding),
                    Align(
                      alignment: Alignment.topLeft,
                      child: FadeTransition(
                        opacity: _fadeInAnimation,
                        child: BackButtonBasic(),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 16),
                            // Logo with animation
                            FadeTransition(
                              opacity: _fadeInAnimation,
                              child: _logoVaxPet(isLargeScreen),
                            ),

                            SizedBox(height: isSmallScreen ? 40 : 50),

                            // Title with animation
                            SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeInAnimation,
                                child: _title(isSmallScreen),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Description with animation
                            SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeInAnimation,
                                child: _description(isSmallScreen),
                              ),
                            ),

                            SizedBox(height: isSmallScreen ? 40 : 50),

                            // Buttons with animation
                            SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeInAnimation,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buttonRegister(
                                      context,
                                      buttonWidth,
                                      buttonHeight,
                                      isSmallScreen,
                                    ),
                                    SizedBox(width: 20),
                                    _buttonSignin(
                                      context,
                                      buttonWidth,
                                      buttonHeight,
                                      isSmallScreen,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Add extra space at bottom to ensure content doesn't overlap with cat-dog image
                            SizedBox(
                              height:
                                  isLargeScreen
                                      ? 100
                                      : (isMediumScreen ? 160 : 180),
                            ),
                          ],
                        ),
                      ),
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

  Widget _logoVaxPet(bool isLargeScreen) {
    return Container(
      alignment: Alignment.center,
      child: SvgPicture.asset(AppVectors.logoVaxPet),
    );
  }

  Widget _title(bool isSmallScreen) {
    return Text(
      'Trung tâm tiêm chủng VaxPet',
      style: TextStyle(
        fontSize: isSmallScreen ? 22 : 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textGray,
        letterSpacing: 0.3,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _description(bool isSmallScreen) {
    return Container(
      constraints: BoxConstraints(maxWidth: 320),
      child: Text(
        'Bảo vệ người bạn nhỏ của bạn mỗi ngày',
        style: TextStyle(
          fontSize: isSmallScreen ? 14 : 16,
          color: AppColors.textGray.withValues(alpha: 0.8),
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buttonRegister(
    BuildContext context,
    double width,
    double height,
    bool isSmallScreen,
  ) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          AppNavigator.push(context, RegisterPage());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Đăng ký',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 15 : 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buttonSignin(
    BuildContext context,
    double width,
    double height,
    bool isSmallScreen,
  ) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          AppNavigator.push(context, SigninPage());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Đăng nhập',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 15 : 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
