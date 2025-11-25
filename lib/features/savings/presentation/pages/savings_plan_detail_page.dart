import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/savings_plan.dart';
import '../bloc/savings_plan_bloc.dart';
import '../bloc/savings_plan_event.dart';
import '../bloc/savings_plan_state.dart';
import '../widgets/add_money_dialog.dart';
import '../widgets/savings_progress_indicator.dart';
import 'add_savings_plan_page.dart';

/// Página de detalle de un plan de ahorro
class SavingsPlanDetailPage extends StatelessWidget {
  final SavingsPlan savingsPlan;

  const SavingsPlanDetailPage({
    super.key,
    required this.savingsPlan,
  });

  IconData _getIcon() {
    if (savingsPlan.icon == 'home') return Icons.home;
    if (savingsPlan.icon == 'flight') return Icons.flight;
    if (savingsPlan.icon == 'directions_car') return Icons.directions_car;
    if (savingsPlan.icon == 'school') return Icons.school;
    if (savingsPlan.icon == 'savings') return Icons.savings;
    if (savingsPlan.icon == 'favorite') return Icons.favorite;
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

  void _showAddMoneyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<SavingsPlanBloc>(),
        child: AddMoneyDialog(savingsPlan: savingsPlan),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Plan'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este plan de ahorro? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<SavingsPlanBloc>().add(
                    DeleteSavingsPlanRequested(planId: savingsPlan.id),
                  );
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Return to list
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _completePlan(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Completar Plan'),
        content: const Text(
          '¿Deseas marcar este plan como completado?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<SavingsPlanBloc>().add(
                    CompleteSavingsPlanRequested(planId: savingsPlan.id),
                  );
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Return to list
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.success),
            child: const Text('Completar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final planColor = _getColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: savingsPlan.status == 'active'
                ? () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<SavingsPlanBloc>(),
                          child: AddSavingsPlanPage(savingsPlan: savingsPlan),
                        ),
                      ),
                    );
                    if (result == true) {
                      Navigator.pop(context, true);
                    }
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: BlocListener<SavingsPlanBloc, SavingsPlanState>(
        listener: (context, state) {
          if (state is SavingsPlanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is SavingsPlanOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context, true);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [planColor, planColor.withOpacity(0.8)],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _getIcon(),
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      savingsPlan.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    if (savingsPlan.description != null &&
                        savingsPlan.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        savingsPlan.description!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Progress Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progreso',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: planColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${savingsPlan.progressPercentage.toStringAsFixed(1)}%',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: planColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SavingsProgressIndicator(
                      progress: savingsPlan.progress,
                      color: planColor,
                      height: 12,
                    ),
                    const SizedBox(height: 24),
                    // Amount Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            'Ahorrado',
                            Formatters.currency(savingsPlan.currentAmount),
                            Icons.account_balance_wallet,
                            planColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            'Meta',
                            Formatters.currency(savingsPlan.targetAmount),
                            Icons.flag,
                            AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            'Restante',
                            Formatters.currency(savingsPlan.remainingAmount),
                            Icons.trending_up,
                            AppColors.error,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            savingsPlan.daysRemaining != null
                                ? 'Días Restantes'
                                : 'Sin Límite',
                            savingsPlan.daysRemaining?.toString() ?? '--',
                            Icons.calendar_today,
                            AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Suggestions (if target date is set)
              if (savingsPlan.targetDate != null &&
                  savingsPlan.suggestedDailySaving != null) ...[
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.info.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: AppColors.info),
                            const SizedBox(width: 8),
                            Text(
                              'Sugerencias',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Para alcanzar tu meta, necesitas ahorrar:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        if (savingsPlan.suggestedDailySaving != null)
                          Text(
                            '" ${Formatters.currency(savingsPlan.suggestedDailySaving!)} al día',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        if (savingsPlan.suggestedMonthlySaving != null)
                          Text(
                            '" ${Formatters.currency(savingsPlan.suggestedMonthlySaving!)} al mes',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Action Buttons
              if (savingsPlan.status == 'active') ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => _showAddMoneyDialog(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar Dinero'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: planColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      if (!savingsPlan.isCompleted) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () => _completePlan(context),
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Marcar como Completado'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.success,
                              side: BorderSide(color: AppColors.success),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
