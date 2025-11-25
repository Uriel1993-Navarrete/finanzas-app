import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/savings_plan.dart';
import '../repositories/savings_plan_repository.dart';

/// Caso de uso para marcar un plan de ahorro como completado
class CompleteSavingsPlan {
  final SavingsPlanRepository repository;

  CompleteSavingsPlan(this.repository);

  Future<Either<Failure, SavingsPlan>> call(String planId) async {
    return await repository.completeSavingsPlan(planId);
  }
}
