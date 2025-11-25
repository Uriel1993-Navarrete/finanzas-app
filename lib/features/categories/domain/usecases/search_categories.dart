import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

/// Caso de uso para buscar categorías por nombre con filtros opcionales
class SearchCategories {
  final CategoryRepository repository;

  SearchCategories(this.repository);

  /// Busca categorías que coincidan con el query
  ///
  /// [userId]: ID del usuario propietario
  /// [query]: Texto de búsqueda (case-insensitive)
  /// [type]: Filtro opcional por tipo ('income' o 'expense')
  /// [isSubcategory]: Filtro opcional (true = solo subcategorías, false = solo principales)
  ///
  /// Retorna lista de categorías que coinciden con los criterios
  Future<Either<Failure, List<Category>>> call({
    required String userId,
    required String query,
    String? type,
    bool? isSubcategory,
  }) async {
    return await repository.searchCategories(
      userId: userId,
      query: query,
      type: type,
      isSubcategory: isSubcategory,
    );
  }
}
