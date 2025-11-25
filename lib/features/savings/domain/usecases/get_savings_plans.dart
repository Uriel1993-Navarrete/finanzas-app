import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/savings_plan.dart';
import '../repositories/savings_plan_repository.dart';

/// Caso de uso para obtener todos los planes de ahorro de un usuario
class GetSavingsPlans {
  final SavingsPlanRepository repository;

  GetSavingsPlans(this.repository);

  Future<Either<Failure, List<SavingsPlan>>> call(String userId) async {
    return await repository.getSavingsPlans(userId);
  }
}

/// Caso de uso para obtener solo los planes activos
class GetActiveSavingsPlans {
  final SavingsPlanRepository repository;

  GetActiveSavingsPlans(this.repository);

  Future<Either<Failure, List<SavingsPlan>>> call(String userId) async {
    return await repository.getActiveSavingsPlans(userId);
  }
}
