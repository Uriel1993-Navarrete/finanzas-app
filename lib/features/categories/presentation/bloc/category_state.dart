part of 'category_bloc.dart';

/// Estados de categorías
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class CategoryInitial extends CategoryState {}

/// Cargando
class CategoryLoading extends CategoryState {}

/// Categorías cargadas
class CategoriesLoaded extends CategoryState {
  final List<Category> categories;

  const CategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

/// Operación exitosa
class CategoryOperationSuccess extends CategoryState {
  final String message;

  const CategoryOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Error
class CategoryError extends CategoryState {
  final String message;

  const CategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
