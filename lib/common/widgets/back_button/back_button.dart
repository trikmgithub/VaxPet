import 'package:flutter/material.dart';
import '../../../core/configs/theme/app_colors.dart';

class BackButtonBasic extends StatelessWidget {
  const BackButtonBasic({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: AppColors.returnBackground,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              spreadRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.returnIcon,
          ),
        ),
      ),
    );
  }
}
