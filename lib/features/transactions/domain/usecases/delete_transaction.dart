import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/transaction_repository.dart';

/// Caso de uso para eliminar una transacción
class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteTransaction(id);
  }
}
