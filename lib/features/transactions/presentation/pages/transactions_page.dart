import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/injection_container.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../categories/presentation/bloc/category_bloc.dart';
import '../bloc/transaction_bloc.dart';
import '../widgets/transaction_list_item.dart';
import 'add_transaction_page.dart';

/// Pantalla de transacciones (Ingresos/Egresos)
class TransactionsPage extends StatefulWidget {
  final String type; // 'income' o 'expense'

  const TransactionsPage({
    super.key,
    required this.type,
  });

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  Widget build(BuildContext context) {
    final isIncome = widget.type == 'income';
    final title = isIncome ? 'Ingresos' : 'Egresos';
    final color = isIncome ? AppColors.income : AppColors.expense;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<TransactionBloc>()),
        BlocProvider(create: (_) => sl<CategoryBloc>()),
      ],
      child: Builder(
        builder: (context) {
          // Cargar transacciones al iniciar
          final authState = context.read<AuthBloc>().state;
          if (authState is AuthAuthenticated) {
            context.read<TransactionBloc>().add(
                  LoadTransactionsByTypeRequested(
                    userId: authState.user.id,
                    type: widget.type,
                  ),
                );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // TODO: Implementar filtros
                  },
                ),
              ],
            ),
            body: BlocConsumer<TransactionBloc, TransactionState>(
              listener: (context, state) {
                if (state is TransactionError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
                if (state is TransactionOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  // Recargar transacciones
                  final authState = context.read<AuthBloc>().state;
                  if (authState is AuthAuthenticated) {
                    context.read<TransactionBloc>().add(
                          LoadTransactionsByTypeRequested(
                            userId: authState.user.id,
                            type: widget.type,
                          ),
                        );
                  }
                }
              },
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TransactionDataLoaded && state.transactions != null) {
                  if (state.transactions!.isEmpty) {
                    return _buildEmptyState(context, isIncome);
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is AuthAuthenticated) {
                        context.read<TransactionBloc>().add(
                              LoadTransactionsByTypeRequested(
                                userId: authState.user.id,
                                type: widget.type,
                              ),
                            );
                      }
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.transactions!.length,
                      itemBuilder: (context, index) {
                        final transaction = state.transactions![index];
                        return TransactionListItem(
                          transaction: transaction,
                          onTap: () {
                            // TODO: Navegar a detalles o editar
                          },
                          onDelete: () {
                            _showDeleteDialog(context, transaction.id);
                          },
                        );
                      },
                    ),
                  );
                }

                return _buildEmptyState(context, isIncome);
              },
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: context.read<TransactionBloc>(),
                        ),
                        BlocProvider.value(
                          value: context.read<CategoryBloc>(),
                        ),
                        BlocProvider.value(
                          value: context.read<AuthBloc>(),
                        ),
                      ],
                      child: AddTransactionPage(type: widget.type),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: Text('Agregar ${isIncome ? 'Ingreso' : 'Egreso'}'),
              backgroundColor: color,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isIncome) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isIncome ? Icons.trending_up : Icons.trending_down,
            size: 100,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'No hay ${isIncome ? 'ingresos' : 'egresos'} registrados',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Presiona el botón + para agregar uno',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String transactionId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar transacción'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar esta transacción?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<TransactionBloc>().add(
                    DeleteTransactionRequested(transactionId: transactionId),
                  );
              Navigator.pop(dialogContext);
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
