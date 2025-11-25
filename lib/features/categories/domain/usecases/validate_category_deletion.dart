import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/category_repository.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';

/// Resultado de la validación de eliminación de categoría
class ValidationResult extends Equatable {
  final bool canDelete;
  final String? reason;

  const ValidationResult({
    required this.canDelete,
    this.reason,
  });

  @override
  List<Object?> get props => [canDelete, reason];
}

/// Caso de uso para validar si una categoría puede ser eliminada
///
/// Reglas de negocio:
/// 1. No tiene transacciones asociadas
/// 2. No tiene subcategorías
/// 3. No es la única categoría de su tipo (income/expense)
class ValidateCategoryDeletion {
  final CategoryRepository categoryRepository;
  final TransactionRepository transactionRepository;

  ValidateCategoryDeletion({
    required this.categoryRepository,
    required this.transactionRepository,
  });

  Future<Either<Failure, ValidationResult>> call(String categoryId) async {
    try {
      // 1. Obtener la categoría
      final categoryResult = await categoryRepository.getCategoryById(categoryId);

      return categoryResult.fold(
        (failure) => Left(failure),
        (category) async {
          // 2. Verificar transacciones asociadas
          final transactionCountResult =
              await transactionRepository.getTransactionCount(categoryId);

          return transactionCountResult.fold(
            (failure) => Left(failure),
            (transactionCount) async {
              if (transactionCount > 0) {
                return Right(ValidationResult(
                  canDelete: false,
                  reason:
                      'Esta categoría tiene $transactionCount ${transactionCount == 1 ? 'transacción asociada' : 'transacciones asociadas'}',
                ));
              }

              // 3. Verificar subcategorías
              final subcategoriesResult =
                  await categoryRepository.getSubcategories(categoryId);

              return subcategoriesResult.fold(
                (failure) => Left(failure),
                (subcategories) async {
                  if (subcategories.isNotEmpty) {
                    return Right(ValidationResult(
                      canDelete: false,
                      reason:
                          'Esta categoría tiene ${subcategories.length} ${subcategories.length == 1 ? 'subcategoría' : 'subcategorías'}',
                    ));
                  }

                  // 4. Verificar que no sea la última categoría de su tipo
                  final categoriesResult =
                      await categoryRepository.getCategoriesByType(
                    category.userId,
                    category.type,
                  );

                  return categoriesResult.fold(
                    (failure) => Left(failure),
                    (categories) {
                      // Filtrar solo categorías principales (sin parent)
                      final mainCategories =
                          categories.where((c) => c.parentId == null).toList();

                      if (mainCategories.length <= 1) {
                        return const Right(ValidationResult(
                          canDelete: false,
                          reason:
                              'Debe existir al menos una categoría de este tipo',
                        ));
                      }

                      // Todas las validaciones pasaron
                      return const Right(ValidationResult(
                        canDelete: true,
                      ));
                    },
                  );
                },
              );
            },
          );
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
