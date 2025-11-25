import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

/// Caso de uso para obtener categorías por tipo
class GetCategoriesByType {
  final CategoryRepository repository;

  GetCategoriesByType(this.repository);

  Future<Either<Failure, List<Category>>> call({
    required String userId,
    required String type,
  }) async {
    return await repository.getCategoriesByType(userId, type);
  }
}
