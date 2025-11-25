import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/savings_plan_repository.dart';

/// Caso de uso para eliminar un plan de ahorro
class DeleteSavingsPlan {
  final SavingsPlanRepository repository;

  DeleteSavingsPlan(this.repository);

  Future<Either<Failure, void>> call(String planId) async {
    return await repository.deleteSavingsPlan(planId);
  }
}
