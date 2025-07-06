import 'package:flutter/material.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';

class CategoryText extends StatelessWidget {
  final String title;
  final double? sizeTitle;
  final TextAlign? textAlign;

  const CategoryText({
    super.key,
    required this.title,
    this.sizeTitle = 20,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: Text(
        title,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: sizeTitle,
          color: AppColors.textGray,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
