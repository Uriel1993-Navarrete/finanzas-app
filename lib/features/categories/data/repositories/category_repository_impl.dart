import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';
import '../models/category_model.dart';

/// Implementación del repositorio de categorías
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Category>>> getCategories(String userId) async {
    try {
      final categories = await remoteDataSource.getCategories(userId);
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategoriesByType(
    String userId,
    String type,
  ) async {
    try {
      final categories =
          await remoteDataSource.getCategoriesByType(userId, type);
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> getCategoryById(String id) async {
    try {
      final category = await remoteDataSource.getCategoryById(id);
      return Right(category);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> createCategory(Category category) async {
    try {
      final categoryModel = CategoryModel(
        id: category.id,
        name: category.name,
        description: category.description,
        icon: category.icon,
        color: category.color,
        type: category.type,
        parentId: category.parentId,
        userId: category.userId,
        createdAt: category.createdAt,
        updatedAt: category.updatedAt,
      );
      final result = await remoteDataSource.createCategory(categoryModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory(Category category) async {
    try {
      final categoryModel = CategoryModel(
        id: category.id,
        name: category.name,
        description: category.description,
        icon: category.icon,
        color: category.color,
        type: category.type,
        parentId: category.parentId,
        userId: category.userId,
        createdAt: category.createdAt,
        updatedAt: category.updatedAt,
      );
      final result = await remoteDataSource.updateCategory(categoryModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await remoteDataSource.deleteCategory(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getSubcategories(
    String parentId,
  ) async {
    try {
      final subcategories = await remoteDataSource.getSubcategories(parentId);
      return Right(subcategories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
