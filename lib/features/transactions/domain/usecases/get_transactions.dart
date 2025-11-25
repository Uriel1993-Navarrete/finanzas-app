import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Caso de uso para obtener todas las transacciones
class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Future<Either<Failure, List<Transaction>>> call(String userId) async {
    return await repository.getTransactions(userId);
  }
}
