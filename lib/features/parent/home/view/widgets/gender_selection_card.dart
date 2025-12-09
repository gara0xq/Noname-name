import 'package:flutter/material.dart';
import 'package:testss/core/constants/app_colors.dart';

class GenderSelectionCard extends StatelessWidget {
  final String gender;
  final String label;
  final Color color;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderSelectionCard({
    super.key,
    required this.gender,
    required this.label,
    required this.color,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.taskCardYellow : Colors.transparent,
              width: 3,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.taskCardYellow.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 2,
                left: gender == 'male' ? 1 : null,
                right: gender == 'female' ? 1 : null,
                child: Image.asset(
                  imagePath,
                  height: 110,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      gender == 'male' ? Icons.boy : Icons.girl,
                      size: 60,
                      color: Colors.white.withOpacity(0.5),
                    );
                  },
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                right: gender == 'male' ? 20 : null,
                left: gender == 'female' ? 20 : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
