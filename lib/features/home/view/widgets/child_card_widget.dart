import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../model/child_model.dart';

class ChildCardWidget extends StatelessWidget {
  final ChildModel child;
  final int index;

  const ChildCardWidget({super.key, required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    final bool isMale = child.gender == 'male';
    final Color cardColor = isMale
        ? AppColors.primaryOrange
        : AppColors.primaryGreen;

    final String childImage = isMale
        ? 'assets/images/boy.png'
        : 'assets/images/girl.png';

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  child.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Row(
                  textDirection: isMale ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset("assets/icons/star.svg"),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      child.points.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: isMale ? -16 : null,
            right: isMale ? null : -16,
            child: Image.asset(
              childImage,
              width: 80,
              height: 100,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  isMale ? Icons.boy : Icons.girl,
                  size: 60,
                  color: Colors.white.withOpacity(0.5),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
