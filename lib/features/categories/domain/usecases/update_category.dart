import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

/// Caso de uso para actualizar una categoría
class UpdateCategory {
  final CategoryRepository repository;

  UpdateCategory(this.repository);

  Future<Either<Failure, Category>> call(Category category) async {
    return await repository.updateCategory(category);
  }
}
