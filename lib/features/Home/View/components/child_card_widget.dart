import 'package:flutter/material.dart';
import '../../../../data/constants/app_colors.dart';

class ChildCardWidget extends StatelessWidget {
  final dynamic child;
  final int index;

  const ChildCardWidget({super.key, required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    final bool isMale = child.gender == 'male';
    final Color cardColor = isMale
        ? AppColors.primaryOrange
        : AppColors.primaryGreen;

    final String childImage = isMale
        ? 'lib/assets/images/boy.png'
        : 'lib/assets/images/girl.png';

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
                  child.name ?? 'No Name',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: isMale
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'lib/assets/images/star.png',
                        width: 16,
                        height: 16,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${child.points ?? 0}',
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