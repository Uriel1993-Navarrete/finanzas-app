import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_datasource.dart';
import '../models/transaction_model.dart';

/// Implementación del repositorio de transacciones
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions(
    String userId,
  ) async {
    try {
      final transactions = await remoteDataSource.getTransactions(userId);
      return Right(transactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByType(
    String userId,
    String type,
  ) async {
    try {
      final transactions =
          await remoteDataSource.getTransactionsByType(userId, type);
      return Right(transactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final transactions = await remoteDataSource.getTransactionsByDateRange(
        userId,
        startDate,
        endDate,
      );
      return Right(transactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    try {
      final transaction = await remoteDataSource.getTransactionById(id);
      return Right(transaction);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> createTransaction(
    Transaction transaction,
  ) async {
    try {
      final transactionModel = TransactionModel(
        id: transaction.id,
        userId: transaction.userId,
        categoryId: transaction.categoryId,
        type: transaction.type,
        amount: transaction.amount,
        description: transaction.description,
        notes: transaction.notes,
        date: transaction.date,
        attachmentUrl: transaction.attachmentUrl,
        createdAt: transaction.createdAt,
        updatedAt: transaction.updatedAt,
      );
      final result = await remoteDataSource.createTransaction(transactionModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> updateTransaction(
    Transaction transaction,
  ) async {
    try {
      final transactionModel = TransactionModel(
        id: transaction.id,
        userId: transaction.userId,
        categoryId: transaction.categoryId,
        type: transaction.type,
        amount: transaction.amount,
        description: transaction.description,
        notes: transaction.notes,
        date: transaction.date,
        attachmentUrl: transaction.attachmentUrl,
        createdAt: transaction.createdAt,
        updatedAt: transaction.updatedAt,
      );
      final result = await remoteDataSource.updateTransaction(transactionModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await remoteDataSource.deleteTransaction(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getMonthlyBalance(
    String userId,
    int year,
    int month,
  ) async {
    try {
      final balance = await remoteDataSource.getMonthlyBalance(
        userId,
        year,
        month,
      );
      return Right(balance);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
