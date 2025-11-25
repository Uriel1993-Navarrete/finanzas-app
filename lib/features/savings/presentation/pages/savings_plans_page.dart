import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/injection_container.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/savings_plan_bloc.dart';
import '../bloc/savings_plan_event.dart';
import '../bloc/savings_plan_state.dart';
import '../widgets/savings_plan_card.dart';
import 'add_savings_plan_page.dart';
import 'savings_plan_detail_page.dart';

/// Página que muestra la lista de planes de ahorro
class SavingsPlansPage extends StatefulWidget {
  const SavingsPlansPage({super.key});

  @override
  State<SavingsPlansPage> createState() => _SavingsPlansPageState();
}

class _SavingsPlansPageState extends State<SavingsPlansPage> {
  String _selectedFilter = 'all'; // 'all', 'active', 'completed'

  @override
  void initState() {
    super.initState();
    _loadSavingsPlans();
  }

  void _loadSavingsPlans() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      if (_selectedFilter == 'active') {
        context.read<SavingsPlanBloc>().add(
              LoadActiveSavingsPlansRequested(userId: authState.user.id),
            );
      } else {
        context.read<SavingsPlanBloc>().add(
              LoadSavingsPlansRequested(userId: authState.user.id),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planes de Ahorro'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedFilter,
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
              _loadSavingsPlans();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('Todos'),
              ),
              const PopupMenuItem(
                value: 'active',
                child: Text('Activos'),
              ),
              const PopupMenuItem(
                value: 'completed',
                child: Text('Completados'),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<SavingsPlanBloc, SavingsPlanState>(
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
            _loadSavingsPlans();
          }
        },
        builder: (context, state) {
          if (state is SavingsPlanLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SavingsPlansLoaded) {
            final filteredPlans = _selectedFilter == 'completed'
                ? state.savingsPlans
                    .where((plan) => plan.status == 'completed')
                    .toList()
                : state.savingsPlans;

            if (filteredPlans.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.savings_outlined,
                      size: 80,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay planes de ahorro',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Crea tu primer plan de ahorro',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadSavingsPlans();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredPlans.length,
                itemBuilder: (context, index) {
                  final plan = filteredPlans[index];
                  return SavingsPlanCard(
                    savingsPlan: plan,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<SavingsPlanBloc>(),
                            child: SavingsPlanDetailPage(savingsPlan: plan),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<SavingsPlanBloc>(),
                child: const AddSavingsPlanPage(),
              ),
            ),
          );

          if (result == true) {
            _loadSavingsPlans();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Plan'),
      ),
    );
  }
}
