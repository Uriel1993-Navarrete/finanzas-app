import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/injection_container.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../categories/presentation/bloc/category_bloc.dart';
import '../../../debug/logs_page.dart';
import '../../../savings/presentation/bloc/savings_plan_bloc.dart';
import '../../../savings/presentation/pages/savings_plans_page.dart';
import '../../../transactions/presentation/bloc/transaction_bloc.dart';
import '../../../transactions/presentation/pages/add_transaction_page.dart';
import '../../../transactions/presentation/pages/transactions_page.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/recent_transaction_card.dart';

/// Página del Dashboard principal
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final now = DateTime.now();
      // Cargar balance mensual
      context.read<TransactionBloc>().add(
            LoadMonthlyBalanceRequested(
              userId: authState.user.id,
              year: now.year,
              month: now.month,
            ),
          );
      // Cargar transacciones recientes
      context.read<TransactionBloc>().add(
            LoadTransactionsRequested(userId: authState.user.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar personalizado
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: AppColors.background,
              title: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola, ${state.user.displayName ?? 'Usuario'}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'Bienvenido de vuelta',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    );
                  }
                  return const Text('Dashboard');
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // TODO: Implementar notificaciones
                  },
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Configuración'),
                      ),
                      onTap: () {
                        // TODO: Navegar a configuración
                      },
                    ),
                    PopupMenuItem(
                      child: const ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Cerrar sesión'),
                      ),
                      onTap: () {
                        context.read<AuthBloc>().add(AuthSignOutRequested());
                      },
                    ),
                  ],
                ),
              ],
            ),

            // Contenido
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance general
                    BlocBuilder<TransactionBloc, TransactionState>(
                      builder: (context, state) {
                        double balance = 0;
                        double income = 0;
                        double expenses = 0;

                        if (state is TransactionDataLoaded && state.balance != null) {
                          income = state.balance!['income'] ?? 0;
                          expenses = state.balance!['expense'] ?? 0;
                          balance = state.balance!['balance'] ?? 0;
                        }

                        return BalanceCard(
                          balance: balance,
                          income: income,
                          expenses: expenses,
                          onTap: () {
                            // Navegar a estadísticas
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Acciones rápidas
                    Text(
                      'Acciones rápidas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: QuickActionButton(
                            icon: Icons.add,
                            label: 'Ingreso',
                            color: AppColors.income,
                            onTap: () => _navigateToAddTransaction('income'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: QuickActionButton(
                            icon: Icons.remove,
                            label: 'Gasto',
                            color: AppColors.expense,
                            onTap: () => _navigateToAddTransaction('expense'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: QuickActionButton(
                            icon: Icons.savings_outlined,
                            label: 'Ahorro',
                            color: AppColors.savings,
                            onTap: () => _navigateToSavingsPlans(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Transacciones recientes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transacciones recientes',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(
                                      value: context.read<AuthBloc>(),
                                    ),
                                  ],
                                  child: const TransactionsPage(type: 'expense'),
                                ),
                              ),
                            );
                          },
                          child: const Text('Ver todas'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Lista de transacciones recientes
                    BlocBuilder<TransactionBloc, TransactionState>(
                      builder: (context, state) {
                        if (state is TransactionDataLoaded && state.transactions != null) {
                          final recentTransactions =
                              state.transactions!.take(5).toList();

                          if (recentTransactions.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Text(
                                  'No hay transacciones recientes',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: recentTransactions
                                .map((transaction) => RecentTransactionCard(
                                      title: transaction.description ??
                                          'Sin descripción',
                                      category: 'Categoría',
                                      amount: transaction.isIncome
                                          ? transaction.amount
                                          : -transaction.amount,
                                      date: transaction.date,
                                    ))
                                .toList(),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transacciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Estadísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        onTap: (index) {
          if (index != 0) {
            _showComingSoonDialog(context, 'Próximamente');
          }
        },
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: 'logs',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LogsPage()),
                );
              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.bug_report, size: 20),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              heroTag: 'add',
              onPressed: () {
                _showAddTransactionSheet();
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _navigateToAddTransaction(String type) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<TransactionBloc>()),
            BlocProvider(create: (_) => sl<CategoryBloc>()),
            BlocProvider.value(value: context.read<AuthBloc>()),
          ],
          child: AddTransactionPage(type: type),
        ),
      ),
    );

    // Recargar datos si se agregó una transacción
    if (result == true) {
      _loadData();
    }
  }

  void _navigateToSavingsPlans() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<SavingsPlanBloc>()),
            BlocProvider.value(value: context.read<AuthBloc>()),
          ],
          child: const SavingsPlansPage(),
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Próximamente'),
        content: Text('La función "$feature" estará disponible pronto.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showAddTransactionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nueva transacción',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.income,
                child: Icon(Icons.add, color: Colors.white),
              ),
              title: const Text('Agregar ingreso'),
              onTap: () {
                Navigator.pop(sheetContext);
                _navigateToAddTransaction('income');
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.expense,
                child: Icon(Icons.remove, color: Colors.white),
              ),
              title: const Text('Agregar gasto'),
              onTap: () {
                Navigator.pop(sheetContext);
                _navigateToAddTransaction('expense');
              },
            ),
          ],
        ),
      ),
    );
  }
}
