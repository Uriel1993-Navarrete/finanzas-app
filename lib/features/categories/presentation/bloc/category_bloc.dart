import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/logger.dart';
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
    AppLogger.info('Loading categories for user: ${event.userId}', tag: 'CategoryBloc');
    emit(CategoryLoading());
    final result = await getCategories(event.userId);
    result.fold(
      (failure) {
        AppLogger.error('Failed to load categories', tag: 'CategoryBloc', error: failure.message);
        emit(CategoryError(message: failure.message));
      },
      (categories) {
        AppLogger.info('Loaded ${categories.length} categories', tag: 'CategoryBloc');
        emit(CategoriesLoaded(categories: categories));
      },
    );
  }

  Future<void> _onLoadCategoriesByTypeRequested(
    LoadCategoriesByTypeRequested event,
    Emitter<CategoryState> emit,
  ) async {
    AppLogger.info('Loading categories by type: ${event.type}', tag: 'CategoryBloc');
    emit(CategoryLoading());
    final result = await getCategoriesByType(
      userId: event.userId,
      type: event.type,
    );
    result.fold(
      (failure) {
        AppLogger.error('Failed to load categories by type', tag: 'CategoryBloc', error: failure.message);
        emit(CategoryError(message: failure.message));
      },
      (categories) {
        AppLogger.info('Loaded ${categories.length} categories of type ${event.type}', tag: 'CategoryBloc');
        emit(CategoriesLoaded(categories: categories));
      },
    );
  }

  Future<void> _onCreateCategoryRequested(
    CreateCategoryRequested event,
    Emitter<CategoryState> emit,
  ) async {
    AppLogger.info('Creating category: ${event.category.name} (${event.category.type})', tag: 'CategoryBloc');
    emit(CategoryLoading());
    final result = await createCategory(event.category);
    result.fold(
      (failure) {
        AppLogger.error('Failed to create category', tag: 'CategoryBloc', error: failure.message);
        emit(CategoryError(message: failure.message));
      },
      (category) {
        AppLogger.info('Category created successfully: ${category.name}', tag: 'CategoryBloc');
        emit(CategoryOperationSuccess(
          message: 'Categoría creada exitosamente',
        ));
      },
    );
  }

  Future<void> _onUpdateCategoryRequested(
    UpdateCategoryRequested event,
    Emitter<CategoryState> emit,
  ) async {
    AppLogger.info('Updating category: ${event.category.id}', tag: 'CategoryBloc');
    emit(CategoryLoading());
    final result = await updateCategory(event.category);
    result.fold(
      (failure) {
        AppLogger.error('Failed to update category', tag: 'CategoryBloc', error: failure.message);
        emit(CategoryError(message: failure.message));
      },
      (category) {
        AppLogger.info('Category updated successfully: ${category.name}', tag: 'CategoryBloc');
        emit(CategoryOperationSuccess(
          message: 'Categoría actualizada exitosamente',
        ));
      },
    );
  }

  Future<void> _onDeleteCategoryRequested(
    DeleteCategoryRequested event,
    Emitter<CategoryState> emit,
  ) async {
    AppLogger.info('Deleting category: ${event.categoryId}', tag: 'CategoryBloc');
    emit(CategoryLoading());
    final result = await deleteCategory(event.categoryId);
    result.fold(
      (failure) {
        AppLogger.error('Failed to delete category', tag: 'CategoryBloc', error: failure.message);
        emit(CategoryError(message: failure.message));
      },
      (_) {
        AppLogger.info('Category deleted successfully', tag: 'CategoryBloc');
        emit(CategoryOperationSuccess(
          message: 'Categoría eliminada exitosamente',
        ));
      },
    );
  }
}
