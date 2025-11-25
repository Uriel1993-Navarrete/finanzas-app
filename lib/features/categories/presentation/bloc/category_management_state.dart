import 'package:equatable/equatable.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/category_with_usage.dart';
import '../../domain/usecases/validate_category_deletion.dart';

/// Estados para gestión avanzada de categorías
abstract class CategoryManagementState extends Equatable {
  const CategoryManagementState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class CategoryManagementInitial extends CategoryManagementState {
  const CategoryManagementInitial();
}

/// Estado de carga
class CategoryManagementLoading extends CategoryManagementState {
  const CategoryManagementLoading();
}

/// Estado cuando se han cargado categorías con información de uso
class CategoriesWithUsageLoaded extends CategoryManagementState {
  final List<CategoryWithUsage> categories;

  const CategoriesWithUsageLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

/// Estado cuando se ha cargado una categoría específica con uso
class CategoryWithUsageLoaded extends CategoryManagementState {
  final CategoryWithUsage category;

  const CategoryWithUsageLoaded(this.category);

  @override
  List<Object?> get props => [category];
}

/// Estado con resultados de búsqueda
class CategorySearchResults extends CategoryManagementState {
  final List<Category> results;
  final String query;

  const CategorySearchResults({
    required this.results,
    required this.query,
  });

  @override
  List<Object?> get props => [results, query];
}

/// Estado con resultado de validación de eliminación
class CategoryDeletionValidated extends CategoryManagementState {
  final ValidationResult validationResult;
  final String categoryId;

  const CategoryDeletionValidated({
    required this.validationResult,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [validationResult, categoryId];
}

/// Estado con resultado de validación de nombre
class CategoryNameValidated extends CategoryManagementState {
  final bool nameExists;
  final String name;

  const CategoryNameValidated({
    required this.nameExists,
    required this.name,
  });

  @override
  List<Object?> get props => [nameExists, name];
}

/// Estado cuando se han cargado subcategorías
class SubcategoriesLoaded extends CategoryManagementState {
  final List<Category> subcategories;
  final String parentId;

  const SubcategoriesLoaded({
    required this.subcategories,
    required this.parentId,
  });

  @override
  List<Object?> get props => [subcategories, parentId];
}

/// Estado de error
class CategoryManagementError extends CategoryManagementState {
  final String message;

  const CategoryManagementError(this.message);

  @override
  List<Object?> get props => [message];
}
