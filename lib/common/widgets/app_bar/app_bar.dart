import 'package:flutter/material.dart';
import 'dart:ui';

import '../../../core/configs/theme/app_colors.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final bool hideBack;
  final double? height;
  final bool roundedBottom;
  final bool withBlurEffect;
  final double elevation;

  const BasicAppbar({
    this.title,
    this.hideBack = false,
    this.action,
    this.actions,
    this.backgroundColor,
    this.height,
    this.leading,
    this.roundedBottom = true,
    this.withBlurEffect = false,
    this.elevation = 2,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin về kích thước màn hình để điều chỉnh UI responsive
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;

    // Xác định các action buttons
    final List<Widget> actionWidgets = [];
    if (action != null) {
      actionWidgets.add(action!);
    }
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: elevation > 0
          ? [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.3),
                blurRadius: elevation * 2,
              ),
            ]
          : null,
      ),
      child: ClipRRect(
        borderRadius: roundedBottom
          ? const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )
          : BorderRadius.zero,
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          toolbarHeight: height ?? 60,
          titleSpacing: 0,
          leadingWidth: leading != null ? 150 : 56,
          title: title ?? const Text(''),
          actions: actionWidgets.isEmpty ? null : actionWidgets,
          flexibleSpace: ClipRect(
            child: withBlurEffect
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: _buildBackgroundGradient(),
                )
              : _buildBackgroundGradient(),
          ),
          leading: leading ?? (hideBack ? null : _buildBackButton(context, isSmallScreen)),
        ),
      ),
    );
  }

  // Widget để tạo nút Back được cải tiến
  Widget _buildBackButton(BuildContext context, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Container(
          height: isSmallScreen ? 36 : 40,
          width: isSmallScreen ? 36 : 40,
          decoration: BoxDecoration(
            color: AppColors.returnBackground,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 16,
            color: AppColors.returnIcon,
          ),
        ),
      ),
    );
  }

  // Widget để tạo background gradient
  Widget _buildBackgroundGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColor ?? AppColors.primary,
            (backgroundColor ?? AppColors.primary).withValues(alpha: 0.8),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 80);
}