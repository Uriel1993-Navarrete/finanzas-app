import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/category_with_usage.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/check_category_name_exists.dart';
import '../../domain/usecases/get_subcategories.dart';
import '../../domain/usecases/search_categories.dart';
import '../../domain/usecases/validate_category_deletion.dart';
import 'category_management_event.dart';
import 'category_management_state.dart';

/// BLoC para gestión avanzada de categorías
class CategoryManagementBloc
    extends Bloc<CategoryManagementEvent, CategoryManagementState> {
  final CategoryRepository repository;
  final CheckCategoryNameExists checkCategoryNameExists;
  final GetSubcategories getSubcategories;
  final SearchCategories searchCategories;
  final ValidateCategoryDeletion validateCategoryDeletion;

  CategoryManagementBloc({
    required this.repository,
    required this.checkCategoryNameExists,
    required this.getSubcategories,
    required this.searchCategories,
    required this.validateCategoryDeletion,
  }) : super(const CategoryManagementInitial()) {
    on<LoadCategoriesWithUsage>(_onLoadCategoriesWithUsage);
    on<LoadCategoryWithUsageRequested>(_onLoadCategoryWithUsage);
    on<SearchCategoriesRequested>(_onSearchCategories);
    on<ValidateCategoryDeletionRequested>(_onValidateCategoryDeletion);
    on<CheckCategoryNameRequested>(_onCheckCategoryName);
    on<LoadSubcategoriesRequested>(_onLoadSubcategories);
  }

  /// Cargar todas las categorías del usuario con información de uso
  Future<void> _onLoadCategoriesWithUsage(
    LoadCategoriesWithUsage event,
    Emitter<CategoryManagementState> emit,
  ) async {
    AppLogger.info('Loading categories with usage for user: ${event.userId}',
        tag: 'CategoryManagementBloc');
    emit(const CategoryManagementLoading());

    try {
      // Obtener todas las categorías del usuario
      final categoriesResult = await repository.getCategories(event.userId);

      await categoriesResult.fold(
        (failure) async {
          AppLogger.error('Failed to load categories',
              tag: 'CategoryManagementBloc', error: failure.message);
          emit(CategoryManagementError(failure.message));
        },
        (categories) async {
          // Para cada categoría, obtener su información de uso
          final categoriesWithUsage = <CategoryWithUsage>[];

          for (final category in categories) {
            final categoryWithUsageResult =
                await repository.getCategoryWithUsage(category.id);

            categoryWithUsageResult.fold(
              (failure) {
                AppLogger.warning('Failed to load usage for category: ${category.id}',
                    tag: 'CategoryManagementBloc');
              },
              (categoryWithUsage) {
                categoriesWithUsage.add(categoryWithUsage);
              },
            );
          }

          AppLogger.info('Loaded ${categoriesWithUsage.length} categories with usage',
              tag: 'CategoryManagementBloc');
          emit(CategoriesWithUsageLoaded(categoriesWithUsage));
        },
      );
    } catch (e) {
      AppLogger.error('Exception loading categories',
          tag: 'CategoryManagementBloc', error: e);
      emit(CategoryManagementError('Error al cargar categorías: $e'));
    }
  }

  /// Cargar una categoría específica con su información de uso
  Future<void> _onLoadCategoryWithUsage(
    LoadCategoryWithUsageRequested event,
    Emitter<CategoryManagementState> emit,
  ) async {
    AppLogger.info('Loading category with usage: ${event.categoryId}',
        tag: 'CategoryManagementBloc');
    emit(const CategoryManagementLoading());

    final result = await repository.getCategoryWithUsage(event.categoryId);

    result.fold(
      (failure) {
        AppLogger.error('Failed to load category with usage',
            tag: 'CategoryManagementBloc', error: failure.message);
        emit(CategoryManagementError(failure.message));
      },
      (categoryWithUsage) {
        AppLogger.info('Category with usage loaded successfully: ${categoryWithUsage.category.name}',
            tag: 'CategoryManagementBloc');
        emit(CategoryWithUsageLoaded(categoryWithUsage));
      },
    );
  }

  /// Buscar categorías con filtros opcionales
  Future<void> _onSearchCategories(
    SearchCategoriesRequested event,
    Emitter<CategoryManagementState> emit,
  ) async {
    AppLogger.info('Searching categories: query="${event.query}", type=${event.type}',
        tag: 'CategoryManagementBloc');
    emit(const CategoryManagementLoading());

    final result = await searchCategories(
      userId: event.userId,
      query: event.query,
      type: event.type,
      isSubcategory: event.isSubcategory,
    );

    result.fold(
      (failure) {
        AppLogger.error('Failed to search categories',
            tag: 'CategoryManagementBloc', error: failure.message);
        emit(CategoryManagementError(failure.message));
      },
      (results) {
        AppLogger.info('Found ${results.length} categories matching query',
            tag: 'CategoryManagementBloc');
        emit(CategorySearchResults(
          results: results,
          query: event.query,
        ));
      },
    );
  }

  /// Validar si una categoría puede ser eliminada
  Future<void> _onValidateCategoryDeletion(
    ValidateCategoryDeletionRequested event,
    Emitter<CategoryManagementState> emit,
  ) async {
    AppLogger.info('Validating category deletion: ${event.categoryId}',
        tag: 'CategoryManagementBloc');
    emit(const CategoryManagementLoading());

    final result = await validateCategoryDeletion(event.categoryId);

    result.fold(
      (failure) {
        AppLogger.error('Failed to validate category deletion',
            tag: 'CategoryManagementBloc', error: failure.message);
        emit(CategoryManagementError(failure.message));
      },
      (validationResult) {
        AppLogger.info('Category deletion validated: canDelete=${validationResult.canDelete}',
            tag: 'CategoryManagementBloc');
        emit(CategoryDeletionValidated(
          validationResult: validationResult,
          categoryId: event.categoryId,
        ));
      },
    );
  }

  /// Verificar si un nombre de categoría ya existe
  Future<void> _onCheckCategoryName(
    CheckCategoryNameRequested event,
    Emitter<CategoryManagementState> emit,
  ) async {
    AppLogger.info('Checking category name: "${event.name}"',
        tag: 'CategoryManagementBloc');
    // No emitir loading para no interrumpir la UI durante validación en tiempo real
    final result = await checkCategoryNameExists(
      userId: event.userId,
      name: event.name,
      type: event.type,
      excludeId: event.excludeId,
    );

    result.fold(
      (failure) {
        AppLogger.error('Failed to check category name',
            tag: 'CategoryManagementBloc', error: failure.message);
        emit(CategoryManagementError(failure.message));
      },
      (nameExists) {
        AppLogger.info('Category name check: exists=$nameExists',
            tag: 'CategoryManagementBloc');
        emit(CategoryNameValidated(
          nameExists: nameExists,
          name: event.name,
        ));
      },
    );
  }

  /// Cargar las subcategorías de una categoría padre
  Future<void> _onLoadSubcategories(
    LoadSubcategoriesRequested event,
    Emitter<CategoryManagementState> emit,
  ) async {
    AppLogger.info('Loading subcategories for parent: ${event.parentId}',
        tag: 'CategoryManagementBloc');
    emit(const CategoryManagementLoading());

    final result = await getSubcategories(event.parentId);

    result.fold(
      (failure) {
        AppLogger.error('Failed to load subcategories',
            tag: 'CategoryManagementBloc', error: failure.message);
        emit(CategoryManagementError(failure.message));
      },
      (subcategories) {
        AppLogger.info('Loaded ${subcategories.length} subcategories',
            tag: 'CategoryManagementBloc');
        emit(SubcategoriesLoaded(
          subcategories: subcategories,
          parentId: event.parentId,
        ));
      },
    );
  }
}
