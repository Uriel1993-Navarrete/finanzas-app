import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/category_repository.dart';

/// Caso de uso para verificar si un nombre de categoría ya existe
/// Útil para validación en tiempo real mientras el usuario escribe
class CheckCategoryNameExists {
  final CategoryRepository repository;

  CheckCategoryNameExists(this.repository);

  /// Verifica si existe una categoría con el nombre dado
  ///
  /// [userId]: ID del usuario propietario
  /// [name]: Nombre a verificar
  /// [type]: Tipo de categoría ('income' o 'expense')
  /// [excludeId]: ID de categoría a excluir (para edición)
  ///
  /// Retorna `true` si el nombre ya existe, `false` si está disponible
  Future<Either<Failure, bool>> call({
    required String userId,
    required String name,
    required String type,
    String? excludeId,
  }) async {
    return await repository.checkCategoryNameExists(
      userId,
      name,
      type,
      excludeId: excludeId,
    );
  }
}
