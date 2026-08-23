import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) {
          final isSelected = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: isSelected ? 24 : 8,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }
}
