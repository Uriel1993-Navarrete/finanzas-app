import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/savings_plan.dart';
import '../../domain/repositories/savings_plan_repository.dart';
import '../datasources/savings_plan_remote_datasource.dart';
import '../models/savings_plan_model.dart';

/// Implementaci�n del repositorio de planes de ahorro
class SavingsPlanRepositoryImpl implements SavingsPlanRepository {
  final SavingsPlanRemoteDataSource remoteDataSource;

  SavingsPlanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SavingsPlan>>> getSavingsPlans(
      String userId) async {
    try {
      final savingsPlans = await remoteDataSource.getSavingsPlans(userId);
      return Right(savingsPlans);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, List<SavingsPlan>>> getActiveSavingsPlans(
      String userId) async {
    try {
      final savingsPlans = await remoteDataSource.getActiveSavingsPlans(userId);
      return Right(savingsPlans);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, SavingsPlan>> getSavingsPlanById(String id) async {
    try {
      final savingsPlan = await remoteDataSource.getSavingsPlanById(id);
      return Right(savingsPlan);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, SavingsPlan>> createSavingsPlan(
      SavingsPlan savingsPlan) async {
    try {
      final model = SavingsPlanModel.fromEntity(savingsPlan);
      final createdPlan = await remoteDataSource.createSavingsPlan(model);
      return Right(createdPlan);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, SavingsPlan>> updateSavingsPlan(
      SavingsPlan savingsPlan) async {
    try {
      final model = SavingsPlanModel.fromEntity(savingsPlan);
      final updatedPlan = await remoteDataSource.updateSavingsPlan(model);
      return Right(updatedPlan);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSavingsPlan(String id) async {
    try {
      await remoteDataSource.deleteSavingsPlan(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, SavingsPlan>> addToSavingsPlan({
    required String planId,
    required double amount,
    String? note,
  }) async {
    try {
      final updatedPlan = await remoteDataSource.addToSavingsPlan(
        planId: planId,
        amount: amount,
        note: note,
      );
      return Right(updatedPlan);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, SavingsPlan>> withdrawFromSavingsPlan({
    required String planId,
    required double amount,
    String? note,
  }) async {
    try {
      final updatedPlan = await remoteDataSource.withdrawFromSavingsPlan(
        planId: planId,
        amount: amount,
        note: note,
      );
      return Right(updatedPlan);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, SavingsPlan>> completeSavingsPlan(
      String planId) async {
    try {
      final completedPlan = await remoteDataSource.completeSavingsPlan(planId);
      return Right(completedPlan);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, SavingsPlan>> cancelSavingsPlan(String planId) async {
    try {
      final cancelledPlan = await remoteDataSource.cancelSavingsPlan(planId);
      return Right(cancelledPlan);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }
}
