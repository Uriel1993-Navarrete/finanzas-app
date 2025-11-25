part of 'category_bloc.dart';

/// Eventos de categorías
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

/// Cargar todas las categorías
class LoadCategoriesRequested extends CategoryEvent {
  final String userId;

  const LoadCategoriesRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Cargar categorías por tipo
class LoadCategoriesByTypeRequested extends CategoryEvent {
  final String userId;
  final String type;

  const LoadCategoriesByTypeRequested({
    required this.userId,
    required this.type,
  });

  @override
  List<Object?> get props => [userId, type];
}

/// Crear categoría
class CreateCategoryRequested extends CategoryEvent {
  final Category category;

  const CreateCategoryRequested({required this.category});

  @override
  List<Object?> get props => [category];
}

/// Actualizar categoría
class UpdateCategoryRequested extends CategoryEvent {
  final Category category;

  const UpdateCategoryRequested({required this.category});

  @override
  List<Object?> get props => [category];
}

/// Eliminar categoría
class DeleteCategoryRequested extends CategoryEvent {
  final String categoryId;

  const DeleteCategoryRequested({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}
