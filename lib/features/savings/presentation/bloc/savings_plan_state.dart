import 'package:equatable/equatable.dart';
import '../../domain/entities/savings_plan.dart';

/// Estados del Bloc de Planes de Ahorro
abstract class SavingsPlanState extends Equatable {
  const SavingsPlanState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class SavingsPlanInitial extends SavingsPlanState {}

/// Estado de carga
class SavingsPlanLoading extends SavingsPlanState {}

/// Planes de ahorro cargados exitosamente
class SavingsPlansLoaded extends SavingsPlanState {
  final List<SavingsPlan> savingsPlans;

  const SavingsPlansLoaded({required this.savingsPlans});

  @override
  List<Object?> get props => [savingsPlans];
}

/// Operación exitosa (crear, actualizar, eliminar, agregar, retirar, completar, cancelar)
class SavingsPlanOperationSuccess extends SavingsPlanState {
  final String message;
  final SavingsPlan? savingsPlan; // Opcional, para operaciones que devuelven un plan

  const SavingsPlanOperationSuccess({
    required this.message,
    this.savingsPlan,
  });

  @override
  List<Object?> get props => [message, savingsPlan];
}

/// Error en alguna operación
class SavingsPlanError extends SavingsPlanState {
  final String message;

  const SavingsPlanError({required this.message});

  @override
  List<Object?> get props => [message];
}
