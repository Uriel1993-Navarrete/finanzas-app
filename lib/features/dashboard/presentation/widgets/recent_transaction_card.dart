import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';

/// Tarjeta de transacción reciente
class RecentTransactionCard extends StatelessWidget {
  final String title;
  final String category;
  final double amount;
  final DateTime date;

  const RecentTransactionCard({
    super.key,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = amount > 0;
    final color = isIncome ? AppColors.income : AppColors.expense;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text(
          category,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Formatters.currency(amount.abs()),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              Formatters.relativeDate(date),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
