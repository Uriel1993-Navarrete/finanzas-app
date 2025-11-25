import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/default_categories.dart';
import '../repositories/category_repository.dart';

/// Caso de uso para inicializar categorías predeterminadas
class InitializeDefaultCategories {
  final CategoryRepository repository;

  InitializeDefaultCategories(this.repository);

  Future<Either<Failure, void>> call(String userId) async {
    try {
      // Verificar si el usuario ya tiene categorías
      final result = await repository.getCategories(userId);

      return result.fold(
        (failure) => Left(failure),
        (existingCategories) async {
          // Si el usuario ya tiene categorías, no hacer nada
          if (existingCategories.isNotEmpty) {
            return const Right(null);
          }

          // Crear categorías predeterminadas
          final defaultCategories = DefaultCategories.getAllDefaultCategories(userId);

          // Guardar cada categoría en la base de datos
          for (final category in defaultCategories) {
            final createResult = await repository.createCategory(category);
            if (createResult.isLeft()) {
              return createResult.fold(
                (failure) => Left(failure),
                (_) => const Right(null),
              );
            }
          }

          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
