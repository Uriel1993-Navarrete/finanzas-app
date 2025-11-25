import 'package:equatable/equatable.dart';

/// Eventos para gestión avanzada de categorías
abstract class CategoryManagementEvent extends Equatable {
  const CategoryManagementEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar todas las categorías con información de uso
class LoadCategoriesWithUsage extends CategoryManagementEvent {
  final String userId;

  const LoadCategoriesWithUsage(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Evento para buscar categorías con filtros opcionales
class SearchCategoriesRequested extends CategoryManagementEvent {
  final String userId;
  final String query;
  final String? type;
  final bool? isSubcategory;

  const SearchCategoriesRequested({
    required this.userId,
    required this.query,
    this.type,
    this.isSubcategory,
  });

  @override
  List<Object?> get props => [userId, query, type, isSubcategory];
}

/// Evento para validar si una categoría puede ser eliminada
class ValidateCategoryDeletionRequested extends CategoryManagementEvent {
  final String categoryId;

  const ValidateCategoryDeletionRequested(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// Evento para verificar si un nombre de categoría ya existe
class CheckCategoryNameRequested extends CategoryManagementEvent {
  final String userId;
  final String name;
  final String type;
  final String? excludeId;

  const CheckCategoryNameRequested({
    required this.userId,
    required this.name,
    required this.type,
    this.excludeId,
  });

  @override
  List<Object?> get props => [userId, name, type, excludeId];
}

/// Evento para cargar las subcategorías de una categoría padre
class LoadSubcategoriesRequested extends CategoryManagementEvent {
  final String parentId;

  const LoadSubcategoriesRequested(this.parentId);

  @override
  List<Object?> get props => [parentId];
}

/// Evento para obtener una categoría con toda su información de uso
class LoadCategoryWithUsageRequested extends CategoryManagementEvent {
  final String categoryId;

  const LoadCategoryWithUsageRequested(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
