import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/savings_plan.dart';
import 'savings_progress_indicator.dart';

/// Widget de tarjeta para mostrar un plan de ahorro
class SavingsPlanCard extends StatelessWidget {
  final SavingsPlan savingsPlan;
  final VoidCallback? onTap;

  const SavingsPlanCard({
    super.key,
    required this.savingsPlan,
    this.onTap,
  });

  IconData _getIcon() {
    if (savingsPlan.icon == 'home') return Icons.home;
    if (savingsPlan.icon == 'flight') return Icons.flight;
    if (savingsPlan.icon == 'directions_car') return Icons.directions_car;
    if (savingsPlan.icon == 'school') return Icons.school;
    if (savingsPlan.icon == 'savings') return Icons.savings;
    return Icons.savings_outlined;
  }

  Color _getColor() {
    if (savingsPlan.color != null) {
      try {
        return Color(int.parse('0xFF${savingsPlan.color!.substring(1)}'));
      } catch (e) {
        return AppColors.savings;
      }
    }
    return AppColors.savings;
  }

  Color _getStatusColor() {
    if (savingsPlan.status == 'completed') return AppColors.success;
    if (savingsPlan.status == 'cancelled') return AppColors.textSecondary;
    if (savingsPlan.isOverdue) return AppColors.error;
    return AppColors.savings;
  }

  String _getStatusText() {
    if (savingsPlan.status == 'completed') return 'Completado';
    if (savingsPlan.status == 'cancelled') return 'Cancelado';
    if (savingsPlan.isOverdue) return 'Vencido';
    if (savingsPlan.daysRemaining != null) {
      final days = savingsPlan.daysRemaining!;
      if (days == 0) return 'Vence hoy';
      if (days == 1) return 'Vence mañana';
      if (days < 0) return 'Vencido';
      return 'Faltan $days días';
    }
    return 'Sin fecha límite';
  }

  @override
  Widget build(BuildContext context) {
    final planColor = _getColor();
    final statusColor = _getStatusColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon, Name, Status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: planColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIcon(),
                      color: planColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          savingsPlan.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getStatusText(),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  // Progress percentage
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: planColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${savingsPlan.progressPercentage.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: planColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Progress bar
              SavingsProgressIndicator(
                progress: savingsPlan.progress,
                color: planColor,
              ),

              const SizedBox(height: 16),

              // Amounts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ahorrado',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Formatters.currency(savingsPlan.currentAmount),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: planColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Meta',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Formatters.currency(savingsPlan.targetAmount),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),

              // Description if available
              if (savingsPlan.description != null &&
                  savingsPlan.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  savingsPlan.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
