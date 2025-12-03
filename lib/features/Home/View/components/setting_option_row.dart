import 'package:flutter/material.dart';
import '../../../../data/constants/app_colors.dart';

class SettingOptionRow extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingOptionRow({
    super.key,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darkPrimary, 
                fontWeight: FontWeight.w500,
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}