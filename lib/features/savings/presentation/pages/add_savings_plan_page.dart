import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../../domain/entities/savings_plan.dart';
import '../bloc/savings_plan_bloc.dart';
import '../bloc/savings_plan_event.dart';
import '../bloc/savings_plan_state.dart';

/// P�gina para crear un nuevo plan de ahorro
class AddSavingsPlanPage extends StatefulWidget {
  final SavingsPlan? savingsPlan; // Para edici�n

  const AddSavingsPlanPage({super.key, this.savingsPlan});

  @override
  State<AddSavingsPlanPage> createState() => _AddSavingsPlanPageState();
}

class _AddSavingsPlanPageState extends State<AddSavingsPlanPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _currentAmountController = TextEditingController();

  DateTime? _targetDate;
  String _selectedIcon = 'savings';
  String _selectedColor = '#6C63FF';

  final List<Map<String, dynamic>> _icons = [
    {'name': 'savings', 'icon': Icons.savings_outlined},
    {'name': 'home', 'icon': Icons.home},
    {'name': 'flight', 'icon': Icons.flight},
    {'name': 'directions_car', 'icon': Icons.directions_car},
    {'name': 'school', 'icon': Icons.school},
    {'name': 'favorite', 'icon': Icons.favorite},
  ];

  final List<String> _colors = [
    '#6C63FF', // Primary
    '#4CAF50', // Green
    '#2196F3', // Blue
    '#FF9800', // Orange
    '#E91E63', // Pink
    '#9C27B0', // Purple
  ];

  @override
  void initState() {
    super.initState();
    if (widget.savingsPlan != null) {
      _nameController.text = widget.savingsPlan!.name;
      _descriptionController.text = widget.savingsPlan!.description ?? '';
      _targetAmountController.text =
          widget.savingsPlan!.targetAmount.toString();
      _currentAmountController.text =
          widget.savingsPlan!.currentAmount.toString();
      _targetDate = widget.savingsPlan!.targetDate;
      _selectedIcon = widget.savingsPlan!.icon ?? 'savings';
      _selectedColor = widget.savingsPlan!.color ?? '#6C63FF';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.savingsPlan != null;

  void _selectTargetDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 years
    );

    if (pickedDate != null) {
      setState(() {
        _targetDate = pickedDate;
      });
    }
  }

  void _saveSavingsPlan() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      return;
    }

    final now = DateTime.now();
    final savingsPlan = SavingsPlan(
      id: _isEditing ? widget.savingsPlan!.id : Uuid().v4(),
      userId: authState.user.id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      targetAmount: double.parse(_targetAmountController.text),
      currentAmount: _isEditing
          ? double.parse(_currentAmountController.text)
          : 0.0,
      startDate: _isEditing ? widget.savingsPlan!.startDate : now,
      targetDate: _targetDate,
      status: _isEditing ? widget.savingsPlan!.status : 'active',
      icon: _selectedIcon,
      color: _selectedColor,
      createdAt: _isEditing ? widget.savingsPlan!.createdAt : now,
      updatedAt: now,
    );

    if (_isEditing) {
      context.read<SavingsPlanBloc>().add(
            UpdateSavingsPlanRequested(savingsPlan: savingsPlan),
          );
    } else {
      context.read<SavingsPlanBloc>().add(
            CreateSavingsPlanRequested(savingsPlan: savingsPlan),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Plan' : 'Nuevo Plan de Ahorro'),
      ),
      body: BlocListener<SavingsPlanBloc, SavingsPlanState>(
        listener: (context, state) {
          if (state is SavingsPlanOperationSuccess) {
            Navigator.of(context).pop(true);
          } else if (state is SavingsPlanError) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                CustomTextField(
                  controller: _nameController,
                  label: 'Nombre del Plan',
                  hint: 'Ej: Casa nueva, Vacaciones, Auto',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Target Amount
                CustomTextField(
                  controller: _targetAmountController,
                  label: 'Meta de Ahorro',
                  hint: '0.00',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.attach_money,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La meta es requerida';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Ingresa una cantidad v�lida';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Current Amount (only when editing)
                if (_isEditing) ...[
                  CustomTextField(
                    controller: _currentAmountController,
                    label: 'Cantidad Actual',
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.savings,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'La cantidad actual es requerida';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount < 0) {
                        return 'Ingresa una cantidad v�lida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Target Date
                InkWell(
                  onTap: _selectTargetDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Fecha Objetivo (Opcional)',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _targetDate == null
                          ? 'Sin fecha l�mite'
                          : '${_targetDate!.day}/${_targetDate!.month}/${_targetDate!.year}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                CustomTextField(
                  controller: _descriptionController,
                  label: 'Descripci�n (Opcional)',
                  hint: 'Detalles sobre tu meta de ahorro',
                ),

                const SizedBox(height: 24),

                // Icon Selector
                Text(
                  'Selecciona un �cono',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _icons.map((iconData) {
                    final isSelected = _selectedIcon == iconData['name'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = iconData['name'];
                        });
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          iconData['icon'],
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Color Selector
                Text(
                  'Selecciona un Color',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _colors.map((colorHex) {
                    final isSelected = _selectedColor == colorHex;
                    final color = Color(int.parse('0xFF${colorHex.substring(1)}'));
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = colorHex;
                        });
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withOpacity(0.5),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveSavingsPlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _isEditing ? 'Actualizar Plan' : 'Crear Plan',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
