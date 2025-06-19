import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class BoxText extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final double? widthWords;
  final double? sizeTitle;
  final double? heightTitle;
  const BoxText({super.key, required this.title, required this.icon, this.onTap, this.widthWords, this.sizeTitle, this.heightTitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(8),
        height: heightTitle ?? 60,
        width: widthWords ?? 140,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.textBlack),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: sizeTitle ?? 12,
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
