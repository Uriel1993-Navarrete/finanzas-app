import 'package:equatable/equatable.dart';
import '../../domain/entities/savings_plan.dart';

/// Eventos del Bloc de Planes de Ahorro
abstract class SavingsPlanEvent extends Equatable {
  const SavingsPlanEvent();

  @override
  List<Object?> get props => [];
}

/// Cargar todos los planes de ahorro de un usuario
class LoadSavingsPlansRequested extends SavingsPlanEvent {
  final String userId;

  const LoadSavingsPlansRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Cargar solo los planes de ahorro activos
class LoadActiveSavingsPlansRequested extends SavingsPlanEvent {
  final String userId;

  const LoadActiveSavingsPlansRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Crear un nuevo plan de ahorro
class CreateSavingsPlanRequested extends SavingsPlanEvent {
  final SavingsPlan savingsPlan;

  const CreateSavingsPlanRequested({required this.savingsPlan});

  @override
  List<Object?> get props => [savingsPlan];
}

/// Actualizar un plan de ahorro existente
class UpdateSavingsPlanRequested extends SavingsPlanEvent {
  final SavingsPlan savingsPlan;

  const UpdateSavingsPlanRequested({required this.savingsPlan});

  @override
  List<Object?> get props => [savingsPlan];
}

/// Eliminar un plan de ahorro
class DeleteSavingsPlanRequested extends SavingsPlanEvent {
  final String planId;

  const DeleteSavingsPlanRequested({required this.planId});

  @override
  List<Object?> get props => [planId];
}

/// Agregar dinero a un plan de ahorro
class AddToSavingsPlanRequested extends SavingsPlanEvent {
  final String planId;
  final double amount;
  final String? note;

  const AddToSavingsPlanRequested({
    required this.planId,
    required this.amount,
    this.note,
  });

  @override
  List<Object?> get props => [planId, amount, note];
}

/// Retirar dinero de un plan de ahorro
class WithdrawFromSavingsPlanRequested extends SavingsPlanEvent {
  final String planId;
  final double amount;
  final String? note;

  const WithdrawFromSavingsPlanRequested({
    required this.planId,
    required this.amount,
    this.note,
  });

  @override
  List<Object?> get props => [planId, amount, note];
}

/// Marcar un plan como completado
class CompleteSavingsPlanRequested extends SavingsPlanEvent {
  final String planId;

  const CompleteSavingsPlanRequested({required this.planId});

  @override
  List<Object?> get props => [planId];
}

/// Cancelar un plan de ahorro
class CancelSavingsPlanRequested extends SavingsPlanEvent {
  final String planId;

  const CancelSavingsPlanRequested({required this.planId});

  @override
  List<Object?> get props => [planId];
}
