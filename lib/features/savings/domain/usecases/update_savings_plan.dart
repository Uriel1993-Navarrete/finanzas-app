import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/savings_plan.dart';
import '../repositories/savings_plan_repository.dart';

/// Caso de uso para actualizar un plan de ahorro
class UpdateSavingsPlan {
  final SavingsPlanRepository repository;

  UpdateSavingsPlan(this.repository);

  Future<Either<Failure, SavingsPlan>> call(SavingsPlan savingsPlan) async {
    return await repository.updateSavingsPlan(savingsPlan);
  }
}
