import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class CustomInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool readOnly;
  final bool obscureText;

  const CustomInputField({
    super.key,
    this.title = "",
    required this.hint,
    this.controller,
    this.validator,
    this.readOnly = false,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.darkPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primaryGreen, width: 2),
          ),
          child: TextFormField(
            controller: controller,
            readOnly: readOnly,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hint,

              hintStyle: TextStyle(
                color: AppColors.darkPrimary.withAlpha(100),
                fontSize: 12,
              ),
              border: InputBorder.none,
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
