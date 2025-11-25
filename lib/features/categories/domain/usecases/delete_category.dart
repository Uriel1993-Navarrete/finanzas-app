import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/category_repository.dart';

/// Caso de uso para eliminar una categoría
class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteCategory(id);
  }
}
