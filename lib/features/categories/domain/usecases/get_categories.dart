import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

/// Caso de uso para obtener todas las categorías
class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  Future<Either<Failure, List<Category>>> call(String userId) async {
    return await repository.getCategories(userId);
  }
}
