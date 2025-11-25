import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/create_category.dart';
import '../../domain/usecases/delete_category.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_categories_by_type.dart';
import '../../domain/usecases/update_category.dart';

part 'category_event.dart';
part 'category_state.dart';

/// Bloc de categorías
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories getCategories;
  final GetCategoriesByType getCategoriesByType;
  final CreateCategory createCategory;
  final UpdateCategory updateCategory;
  final DeleteCategory deleteCategory;

  CategoryBloc({
    required this.getCategories,
    required this.getCategoriesByType,
    required this.createCategory,
    required this.updateCategory,
    required this.deleteCategory,
  }) : super(CategoryInitial()) {
    on<LoadCategoriesRequested>(_onLoadCategoriesRequested);
    on<LoadCategoriesByTypeRequested>(_onLoadCategoriesByTypeRequested);
    on<CreateCategoryRequested>(_onCreateCategoryRequested);
    on<UpdateCategoryRequested>(_onUpdateCategoryRequested);
    on<DeleteCategoryRequested>(_onDeleteCategoryRequested);
  }

  Future<void> _onLoadCategoriesRequested(
    LoadCategoriesRequested event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    final result = await getCategories(event.userId);
    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (categories) => emit(CategoriesLoaded(categories: categories)),
    );
  }

  Future<void> _onLoadCategoriesByTypeRequested(
    LoadCategoriesByTypeRequested event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    final result = await getCategoriesByType(
      userId: event.userId,
      type: event.type,
    );
    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (categories) => emit(CategoriesLoaded(categories: categories)),
    );
  }

  Future<void> _onCreateCategoryRequested(
    CreateCategoryRequested event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    final result = await createCategory(event.category);
    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (category) => emit(CategoryOperationSuccess(
        message: 'Categoría creada exitosamente',
      )),
    );
  }

  Future<void> _onUpdateCategoryRequested(
    UpdateCategoryRequested event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    final result = await updateCategory(event.category);
    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (category) => emit(CategoryOperationSuccess(
        message: 'Categoría actualizada exitosamente',
      )),
    );
  }

  Future<void> _onDeleteCategoryRequested(
    DeleteCategoryRequested event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    final result = await deleteCategory(event.categoryId);
    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (_) => emit(CategoryOperationSuccess(
        message: 'Categoría eliminada exitosamente',
      )),
    );
  }
}
