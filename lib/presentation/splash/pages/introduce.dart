import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vaxpet/presentation/splash/pages/register_signin.dart';

import '../../../common/helper/navigation/app_navigation.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/configs/theme/app_colors.dart';

class IntroducePage extends StatefulWidget {
  const IntroducePage({super.key});

  @override
  State<IntroducePage> createState() => _IntroducePageState();
}

class _IntroducePageState extends State<IntroducePage> with SingleTickerProviderStateMixin {
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

    // Adjust padding based on screen size
    final horizontalPadding = isSmallScreen ? 16.0 : (isMediumScreen ? 24.0 : 32.0);
    final topPadding = isSmallScreen ? 60.0 : (isMediumScreen ? 80.0 : 100.0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFF5F9FF),
              Color(0xFFEDF5FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: topPadding,
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: 16,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo with fade-in animation
                        FadeTransition(
                          opacity: _fadeInAnimation,
                          child: _logoVaxPet(isLargeScreen),
                        ),

                        // Pet image for visual interest
                        SizedBox(height: isSmallScreen ? 40.0 : 60.0),

                        // Title with slide animation
                        SizedBox(height: isSmallScreen ? 40.0 : 60.0),
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeInAnimation,
                            child: _title(isSmallScreen),
                          ),
                        ),

                        // Description with slide animation
                        const SizedBox(height: 16),
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeInAnimation,
                            child: _description(isSmallScreen, isMediumScreen),
                          ),
                        ),

                        // Button moved up, now inside the scrollview
                        SizedBox(height: isSmallScreen ? 40.0 : 60.0),
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeInAnimation,
                            child: _buttonGetStarted(context, isSmallScreen, isMediumScreen),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Empty SizedBox where the button used to be
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoVaxPet(bool isLargeScreen) {
    return Container(
      alignment: Alignment.center,
      child: SvgPicture.asset(
        AppVectors.logoVaxPet,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _title(bool isSmallScreen) {
    return Text(
      'Trung tâm tiêm chủng VaxPet',
      style: TextStyle(
        fontSize: isSmallScreen ? 22 : 26,
        fontWeight: FontWeight.bold,
        color: AppColors.textGray,
        letterSpacing: 0.3,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _description(bool isSmallScreen, bool isMediumScreen) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isMediumScreen ? 320 : 480,
      ),
      child: Text(
        'Theo dõi lịch tiêm chủng và chăm sóc sức khỏe cho thú cưng dễ dàng hơn bao giờ hết.',
        style: TextStyle(
          fontSize: isSmallScreen ? 14 : 16,
          color: AppColors.textGray.withOpacity(0.8),
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buttonGetStarted(BuildContext context, bool isSmallScreen, bool isMediumScreen) {
    return SizedBox(
      width: double.infinity,
      height: isSmallScreen ? 50 : 56,
      child: ElevatedButton(
        onPressed: () {
          AppNavigator.push(context, const RegisterSigninPage());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
          shadowColor: AppColors.primary.withOpacity(0.4),
        ),
        child: Text(
          'Bắt đầu',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
