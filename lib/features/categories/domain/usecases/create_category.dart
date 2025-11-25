import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

/// Caso de uso para crear una categoría
class CreateCategory {
  final CategoryRepository repository;

  CreateCategory(this.repository);

  Future<Either<Failure, Category>> call(Category category) async {
    return await repository.createCategory(category);
  }
}
