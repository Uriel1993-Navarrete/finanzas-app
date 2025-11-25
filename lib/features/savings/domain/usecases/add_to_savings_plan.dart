import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/savings_plan.dart';
import '../repositories/savings_plan_repository.dart';

/// Caso de uso para agregar dinero a un plan de ahorro
class AddToSavingsPlan {
  final SavingsPlanRepository repository;

  AddToSavingsPlan(this.repository);

  Future<Either<Failure, SavingsPlan>> call({
    required String planId,
    required double amount,
    String? note,
  }) async {
    return await repository.addToSavingsPlan(
      planId: planId,
      amount: amount,
      note: note,
    );
  }
}
