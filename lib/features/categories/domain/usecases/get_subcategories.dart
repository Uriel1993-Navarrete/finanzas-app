import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

/// Caso de uso para obtener subcategorías de una categoría padre
class GetSubcategories {
  final CategoryRepository repository;

  GetSubcategories(this.repository);

  /// Obtiene todas las subcategorías de una categoría padre
  ///
  /// [parentId]: ID de la categoría padre
  ///
  /// Retorna lista de subcategorías o Failure si hay error
  Future<Either<Failure, List<Category>>> call(String parentId) async {
    return await repository.getSubcategories(parentId);
  }
}
