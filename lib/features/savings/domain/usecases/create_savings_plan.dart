import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/savings_plan.dart';
import '../repositories/savings_plan_repository.dart';

/// Caso de uso para crear un nuevo plan de ahorro
class CreateSavingsPlan {
  final SavingsPlanRepository repository;

  CreateSavingsPlan(this.repository);

  Future<Either<Failure, SavingsPlan>> call(SavingsPlan savingsPlan) async {
    return await repository.createSavingsPlan(savingsPlan);
  }
}
