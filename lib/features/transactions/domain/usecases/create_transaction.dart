import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Caso de uso para crear una transacción
class CreateTransaction {
  final TransactionRepository repository;

  CreateTransaction(this.repository);

  Future<Either<Failure, Transaction>> call(Transaction transaction) async {
    return await repository.createTransaction(transaction);
  }
}
