import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';

/// Repositorio de transacciones
abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getTransactions(String userId);
  Future<Either<Failure, List<Transaction>>> getTransactionsByType(
    String userId,
    String type,
  );
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, Transaction>> getTransactionById(String id);
  Future<Either<Failure, Transaction>> createTransaction(Transaction transaction);
  Future<Either<Failure, Transaction>> updateTransaction(Transaction transaction);
  Future<Either<Failure, void>> deleteTransaction(String id);
  Future<Either<Failure, Map<String, double>>> getMonthlyBalance(
    String userId,
    int year,
    int month,
  );
}
