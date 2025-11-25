import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../entities/category_with_usage.dart';

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

  // Nuevos métodos para gestión avanzada de categorías
  Future<Either<Failure, bool>> checkCategoryNameExists(
    String userId,
    String name,
    String type, {
    String? excludeId,
  });

  Future<Either<Failure, CategoryWithUsage>> getCategoryWithUsage(String id);

  Future<Either<Failure, List<Category>>> searchCategories({
    required String userId,
    required String query,
    String? type,
    bool? isSubcategory,
  });
}
