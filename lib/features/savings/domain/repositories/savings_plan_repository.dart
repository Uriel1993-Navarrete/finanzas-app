import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/savings_plan.dart';

/// Interfaz del repositorio de planes de ahorro
abstract class SavingsPlanRepository {
  /// Obtiene todos los planes de ahorro de un usuario
  Future<Either<Failure, List<SavingsPlan>>> getSavingsPlans(String userId);

  /// Obtiene los planes de ahorro activos de un usuario
  Future<Either<Failure, List<SavingsPlan>>> getActiveSavingsPlans(String userId);

  /// Obtiene un plan de ahorro por ID
  Future<Either<Failure, SavingsPlan>> getSavingsPlanById(String id);

  /// Crea un nuevo plan de ahorro
  Future<Either<Failure, SavingsPlan>> createSavingsPlan(SavingsPlan savingsPlan);

  /// Actualiza un plan de ahorro existente
  Future<Either<Failure, SavingsPlan>> updateSavingsPlan(SavingsPlan savingsPlan);

  /// Elimina un plan de ahorro
  Future<Either<Failure, void>> deleteSavingsPlan(String id);

  /// Agrega dinero a un plan de ahorro
  Future<Either<Failure, SavingsPlan>> addToSavingsPlan({
    required String planId,
    required double amount,
    String? note,
  });

  /// Retira dinero de un plan de ahorro
  Future<Either<Failure, SavingsPlan>> withdrawFromSavingsPlan({
    required String planId,
    required double amount,
    String? note,
  });

  /// Marca un plan de ahorro como completado
  Future<Either<Failure, SavingsPlan>> completeSavingsPlan(String planId);

  /// Cancela un plan de ahorro
  Future<Either<Failure, SavingsPlan>> cancelSavingsPlan(String planId);
}
