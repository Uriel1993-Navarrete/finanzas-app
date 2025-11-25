import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';

/// Repositorio de categorías
abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories(String userId);
  Future<Either<Failure, List<Category>>> getCategoriesByType(
    String userId,
    String type,
  );
  Future<Either<Failure, Category>> getCategoryById(String id);
  Future<Either<Failure, Category>> createCategory(Category category);
  Future<Either<Failure, Category>> updateCategory(Category category);
  Future<Either<Failure, void>> deleteCategory(String id);
  Future<Either<Failure, List<Category>>> getSubcategories(String parentId);
}
