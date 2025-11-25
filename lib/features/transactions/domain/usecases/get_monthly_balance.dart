import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/transaction_repository.dart';

/// Caso de uso para obtener balance mensual
class GetMonthlyBalance {
  final TransactionRepository repository;

  GetMonthlyBalance(this.repository);

  Future<Either<Failure, Map<String, double>>> call({
    required String userId,
    required int year,
    required int month,
  }) async {
    return await repository.getMonthlyBalance(userId, year, month);
  }
}
