import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/category_with_usage.dart';

/// Widget para mostrar información de uso de una categoría
/// Incluye: transacciones, monto total, subcategorías
///
/// Uso:
/// ```dart
/// CategoryUsageWidget(
///   categoryWithUsage: categoryData,
///   showDetails: true,
/// )
/// ```
class CategoryUsageWidget extends StatelessWidget {
  /// Datos de la categoría con información de uso
  final CategoryWithUsage categoryWithUsage;

  /// Si true, muestra detalles expandidos
  final bool showDetails;

  /// Si true, muestra advertencia cuando no se puede eliminar
  final bool showDeletionWarning;

  const CategoryUsageWidget({
    super.key,
    required this.categoryWithUsage,
    this.showDetails = true,
    this.showDeletionWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Información de uso',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Usage stats
            _buildStatRow(
              context,
              icon: Icons.receipt_long,
              label: 'Transacciones',
              value: '${categoryWithUsage.transactionCount}',
              color: AppColors.info,
            ),
            const SizedBox(height: 12),
            _buildStatRow(
              context,
              icon: Icons.attach_money,
              label: 'Monto total',
              value: Formatters.currency(categoryWithUsage.totalAmount),
              color: categoryWithUsage.category.type == 'income'
                  ? AppColors.income
                  : AppColors.expense,
            ),
            const SizedBox(height: 12),
            _buildStatRow(
              context,
              icon: Icons.folder,
              label: 'Subcategorías',
              value: '${categoryWithUsage.subcategories.length}',
              color: AppColors.warning,
            ),

            if (showDetails) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Deletion status
              _buildDeletionStatus(context),
            ],

            // Warning banner if needed
            if (showDeletionWarning && !categoryWithUsage.canBeDeleted) ...[
              const SizedBox(height: 16),
              _buildWarningBanner(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDeletionStatus(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: categoryWithUsage.canBeDeleted
            ? AppColors.success.withOpacity(0.1)
            : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: categoryWithUsage.canBeDeleted
              ? AppColors.success
              : AppColors.error,
        ),
      ),
      child: Row(
        children: [
          Icon(
            categoryWithUsage.canBeDeleted
                ? Icons.check_circle
                : Icons.warning,
            color: categoryWithUsage.canBeDeleted
                ? AppColors.success
                : AppColors.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              categoryWithUsage.canBeDeleted
                  ? 'Esta categoría puede eliminarse'
                  : 'No se puede eliminar (tiene transacciones o subcategorías)',
              style: TextStyle(
                color: categoryWithUsage.canBeDeleted
                    ? AppColors.success
                    : AppColors.error,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warning),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info,
            color: AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¿Por qué no puedo eliminarla?',
                  style: TextStyle(
                    color: AppColors.warning,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  categoryWithUsage.transactionCount > 0
                      ? 'Elimina primero las ${categoryWithUsage.transactionCount} transacciones asociadas.'
                      : 'Elimina primero las ${categoryWithUsage.subcategories.length} subcategorías.',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget compacto para mostrar uso en listas
class CompactUsageIndicator extends StatelessWidget {
  final int transactionCount;
  final double totalAmount;
  final bool canBeDeleted;

  const CompactUsageIndicator({
    super.key,
    required this.transactionCount,
    required this.totalAmount,
    required this.canBeDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Transaction count
        _buildCompactStat(
          icon: Icons.receipt_long,
          value: transactionCount.toString(),
          color: AppColors.info,
        ),
        const SizedBox(width: 8),
        // Amount
        _buildCompactStat(
          icon: Icons.attach_money,
          value: Formatters.compactCurrency(totalAmount),
          color: AppColors.success,
        ),
        const SizedBox(width: 8),
        // Deletion status
        Icon(
          canBeDeleted ? Icons.delete_outline : Icons.lock,
          size: 16,
          color: canBeDeleted ? AppColors.textSecondary : AppColors.error,
        ),
      ],
    );
  }

  Widget _buildCompactStat({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
