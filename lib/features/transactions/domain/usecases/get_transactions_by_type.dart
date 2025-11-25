import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Caso de uso para obtener transacciones por tipo
class GetTransactionsByType {
  final TransactionRepository repository;

  GetTransactionsByType(this.repository);

  Future<Either<Failure, List<Transaction>>> call({
    required String userId,
    required String type,
  }) async {
    return await repository.getTransactionsByType(userId, type);
  }
}
