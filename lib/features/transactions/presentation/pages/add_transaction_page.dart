import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/bloc/category_bloc.dart';
import '../../domain/entities/transaction.dart' as domain;
import '../bloc/transaction_bloc.dart';
import '../widgets/category_selector.dart';

/// Pantalla para agregar/editar transacción
class AddTransactionPage extends StatefulWidget {
  final String type; // 'income' o 'expense'
  final domain.Transaction? transaction; // Para editar

  const AddTransactionPage({
    super.key,
    required this.type,
    this.transaction,
  });

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();

    // Si es edición, prellenar datos
    if (widget.transaction != null) {
      _amountController.text = widget.transaction!.amount.toString();
      _descriptionController.text = widget.transaction!.description ?? '';
      _notesController.text = widget.transaction!.notes ?? '';
      _selectedDate = widget.transaction!.date;
    }
  }

  void _loadCategories() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<CategoryBloc>().add(
            LoadCategoriesByTypeRequested(
              userId: authState.user.id,
              type: widget.type,
            ),
          );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    AppLogger.info('Guardando transacción', tag: 'TRANSACTION', data: {
      'type': widget.type,
      'isEdit': widget.transaction != null,
    });

    if (!_formKey.currentState!.validate()) {
      AppLogger.warning('Formulario de transacción inválido', tag: 'TRANSACTION');
      return;
    }

    if (_selectedCategory == null) {
      AppLogger.warning('No se seleccionó categoría', tag: 'TRANSACTION');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una categoría'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      AppLogger.error('Usuario no autenticado al guardar transacción', tag: 'TRANSACTION');
      return;
    }

    final transaction = domain.Transaction(
      id: widget.transaction?.id ?? Uuid().v4(),
      userId: authState.user.id,
      categoryId: _selectedCategory!.id,
      type: widget.type,
      amount: double.parse(_amountController.text),
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      date: _selectedDate,
      createdAt: widget.transaction?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    AppLogger.debug('Transacción creada', tag: 'TRANSACTION', data: {
      'id': transaction.id,
      'userId': transaction.userId,
      'categoryId': transaction.categoryId,
      'type': transaction.type,
      'amount': transaction.amount,
      'date': transaction.date.toIso8601String(),
    });

    if (widget.transaction == null) {
      AppLogger.info('Creando nueva transacción', tag: 'TRANSACTION');
      context.read<TransactionBloc>().add(
            CreateTransactionRequested(transaction: transaction),
          );
    } else {
      AppLogger.info('Actualizando transacción existente', tag: 'TRANSACTION');
      context.read<TransactionBloc>().add(
            UpdateTransactionRequested(transaction: transaction),
          );
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.type == 'income'
                  ? AppColors.income
                  : AppColors.expense,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = widget.type == 'income';
    final color = isIncome ? AppColors.income : AppColors.expense;
    final title = widget.transaction == null
        ? 'Agregar ${isIncome ? 'Ingreso' : 'Egreso'}'
        : 'Editar ${isIncome ? 'Ingreso' : 'Egreso'}';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionOperationSuccess) {
            Navigator.pop(context, true);
          }
          if (state is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Monto
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    prefixStyle:
                        Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                    hintText: '0.00',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa el monto';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Monto inválido';
                    }
                    if (double.parse(value) <= 0) {
                      return 'El monto debe ser mayor a 0';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Categoría
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    // Mostrar loading mientras se cargan las categorías
                    if (state is CategoryLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    // Si hay error al cargar categorías
                    if (state is CategoryError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppColors.error,
                                size: 48,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Error al cargar categorías',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.message,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _loadCategories,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    List<Category> categories = [];

                    if (state is CategoriesLoaded) {
                      categories = state.categories;
                      AppLogger.debug(
                        'Categorías cargadas desde BD',
                        tag: 'TRANSACTION',
                        data: {'count': categories.length, 'type': widget.type},
                      );
                    }

                    // Si no hay categorías después de cargar, mostrar mensaje
                    if (categories.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.category_outlined,
                                color: AppColors.textSecondary,
                                size: 48,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No hay categorías disponibles',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Por favor, cierra sesión y vuelve a iniciar sesión para crear las categorías predeterminadas.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return CategorySelector(
                      categories: categories,
                      selectedCategory: _selectedCategory,
                      onSelected: (category) {
                        setState(() {
                          _selectedCategory = category;
                        });
                        AppLogger.debug(
                          'Categoría seleccionada',
                          tag: 'TRANSACTION',
                          data: {
                            'categoryId': category.id,
                            'categoryName': category.name,
                          },
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Fecha
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Descripción
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Ej: Compra de supermercado',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLength: 100,
                ),

                const SizedBox(height: 16),

                // Notas
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notas (opcional)',
                    hintText: 'Detalles adicionales...',
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLines: 3,
                  maxLength: 500,
                ),

                const SizedBox(height: 32),

                // Botón guardar
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveTransaction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            widget.transaction == null ? 'Guardar' : 'Actualizar',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
