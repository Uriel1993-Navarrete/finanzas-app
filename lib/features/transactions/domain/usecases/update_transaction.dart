import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Caso de uso para actualizar una transacción
class UpdateTransaction {
  final TransactionRepository repository;

  UpdateTransaction(this.repository);

  Future<Either<Failure, Transaction>> call(Transaction transaction) async {
    return await repository.updateTransaction(transaction);
  }
}
