import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/savings_plan.dart';
import '../bloc/savings_plan_bloc.dart';
import '../bloc/savings_plan_event.dart';
import '../bloc/savings_plan_state.dart';

/// Diálogo para agregar dinero a un plan de ahorro
class AddMoneyDialog extends StatefulWidget {
  final SavingsPlan savingsPlan;

  const AddMoneyDialog({super.key, required this.savingsPlan});

  @override
  State<AddMoneyDialog> createState() => _AddMoneyDialogState();
}

class _AddMoneyDialogState extends State<AddMoneyDialog> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _addMoney() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(_amountController.text);
    context.read<SavingsPlanBloc>().add(
          AddToSavingsPlanRequested(
            planId: widget.savingsPlan.id,
            amount: amount,
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavingsPlanBloc, SavingsPlanState>(
      listener: (context, state) {
        if (state is SavingsPlanOperationSuccess) {
          Navigator.of(context).pop();
        } else if (state is SavingsPlanError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: AlertDialog(
        title: const Text('Agregar Dinero'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Cantidad',
                  hintText: '0.00',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa una cantidad';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Ingresa una cantidad válida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Nota (Opcional)',
                  hintText: 'Ej: Ahorro del mes de enero',
                  prefixIcon: const Icon(Icons.note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _addMoney,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.savings,
              foregroundColor: Colors.white,
            ),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
