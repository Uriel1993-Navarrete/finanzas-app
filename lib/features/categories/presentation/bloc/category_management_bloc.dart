import 'package:flutter_bloc/flutter_bloc.dart';
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
    emit(const CategoryManagementLoading());

    try {
      // Obtener todas las categorías del usuario
      final categoriesResult = await repository.getCategories(event.userId);

      await categoriesResult.fold(
        (failure) async {
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
                // Si falla para una categoría, continuar con las demás
                // pero podríamos loguear el error
              },
              (categoryWithUsage) {
                categoriesWithUsage.add(categoryWithUsage);
              },
            );
          }

          emit(CategoriesWithUsageLoaded(categoriesWithUsage));
        },
      );
    } catch (e) {
      emit(CategoryManagementError('Error al cargar categorías: $e'));
    }
  }

  /// Cargar una categoría específica con su información de uso
  Future<void> _onLoadCategoryWithUsage(
    LoadCategoryWithUsageRequested event,
    Emitter<CategoryManagementState> emit,
  ) async {
    emit(const CategoryManagementLoading());

    final result = await repository.getCategoryWithUsage(event.categoryId);

    result.fold(
      (failure) => emit(CategoryManagementError(failure.message)),
      (categoryWithUsage) =>
          emit(CategoryWithUsageLoaded(categoryWithUsage)),
    );
  }

  /// Buscar categorías con filtros opcionales
  Future<void> _onSearchCategories(
    SearchCategoriesRequested event,
    Emitter<CategoryManagementState> emit,
  ) async {
    emit(const CategoryManagementLoading());

    final result = await searchCategories(
      userId: event.userId,
      query: event.query,
      type: event.type,
      isSubcategory: event.isSubcategory,
    );

    result.fold(
      (failure) => emit(CategoryManagementError(failure.message)),
      (results) => emit(CategorySearchResults(
        results: results,
        query: event.query,
      )),
    );
  }

  /// Validar si una categoría puede ser eliminada
  Future<void> _onValidateCategoryDeletion(
    ValidateCategoryDeletionRequested event,
    Emitter<CategoryManagementState> emit,
  ) async {
    emit(const CategoryManagementLoading());

    final result = await validateCategoryDeletion(event.categoryId);

    result.fold(
      (failure) => emit(CategoryManagementError(failure.message)),
      (validationResult) => emit(CategoryDeletionValidated(
        validationResult: validationResult,
        categoryId: event.categoryId,
      )),
    );
  }

  /// Verificar si un nombre de categoría ya existe
  Future<void> _onCheckCategoryName(
    CheckCategoryNameRequested event,
    Emitter<CategoryManagementState> emit,
  ) async {
    // No emitir loading para no interrumpir la UI durante validación en tiempo real
    final result = await checkCategoryNameExists(
      userId: event.userId,
      name: event.name,
      type: event.type,
      excludeId: event.excludeId,
    );

    result.fold(
      (failure) => emit(CategoryManagementError(failure.message)),
      (nameExists) => emit(CategoryNameValidated(
        nameExists: nameExists,
        name: event.name,
      )),
    );
  }

  /// Cargar las subcategorías de una categoría padre
  Future<void> _onLoadSubcategories(
    LoadSubcategoriesRequested event,
    Emitter<CategoryManagementState> emit,
  ) async {
    emit(const CategoryManagementLoading());

    final result = await getSubcategories(event.parentId);

    result.fold(
      (failure) => emit(CategoryManagementError(failure.message)),
      (subcategories) => emit(SubcategoriesLoaded(
        subcategories: subcategories,
        parentId: event.parentId,
      )),
    );
  }
}
