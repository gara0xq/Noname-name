import 'package:flutter/material.dart';
import '../../../../data/constants/app_colors.dart';

class AddChildButton extends StatelessWidget {
  const AddChildButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          print('Add Child Pressed');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          '+ Add child',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}