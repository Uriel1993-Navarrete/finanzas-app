import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Widget de indicador de progreso personalizado para planes de ahorro
class SavingsProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color? color;
  final double height;

  const SavingsProgressIndicator({
    super.key,
    required this.progress,
    this.color,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? AppColors.savings;

    return Stack(
      children: [
        // Background
        Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
        // Progress
        FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  progressColor,
                  progressColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(height / 2),
              boxShadow: [
                BoxShadow(
                  color: progressColor.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
