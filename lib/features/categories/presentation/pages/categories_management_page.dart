import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_management_bloc.dart';
import '../bloc/category_management_event.dart';
import '../bloc/category_management_state.dart';
import '../widgets/category_list_item_widget.dart';
import '../widgets/search_bar_widget.dart';
import 'category_form_page.dart';

/// Página principal de gestión de categorías
/// Muestra lista de categorías con búsqueda y permite crear/editar/eliminar
class CategoriesManagementPage extends StatefulWidget {
  const CategoriesManagementPage({super.key});

  @override
  State<CategoriesManagementPage> createState() =>
      _CategoriesManagementPageState();
}

class _CategoriesManagementPageState extends State<CategoriesManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String? _selectedType; // 'income' o 'expense'

  @override
  void initState() {
    super.initState();
    AppLogger.info('Initializing page', tag: 'CategoriesManagementPage');
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadCategories();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _selectedType = null; // Todas
            break;
          case 1:
            _selectedType = 'income'; // Ingresos
            break;
          case 2:
            _selectedType = 'expense'; // Gastos
            break;
        }
      });
      AppLogger.info('Tab changed to: ${_selectedType ?? "all"}',
          tag: 'CategoriesManagementPage');
      _performSearch();
    }
  }

  void _loadCategories() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      AppLogger.info('Loading categories for user: ${authState.user.id}',
          tag: 'CategoriesManagementPage');
      context.read<CategoryManagementBloc>().add(
            LoadCategoriesWithUsage(authState.user.id),
          );
    }
  }

  void _performSearch() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      if (_searchQuery.isEmpty && _selectedType == null) {
        // Si no hay búsqueda ni filtro, cargar todas
        _loadCategories();
      } else {
        AppLogger.info('Searching: query="$_searchQuery", type=$_selectedType',
            tag: 'CategoriesManagementPage');
        context.read<CategoryManagementBloc>().add(
              SearchCategoriesRequested(
                userId: authState.user.id,
                query: _searchQuery,
                type: _selectedType,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Categorías'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Todas'),
            Tab(text: 'Ingresos'),
            Tab(text: 'Gastos'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              hintText: 'Buscar categorías...',
              onSearchChanged: (query) {
                setState(() => _searchQuery = query);
                _performSearch();
              },
              accentColor: AppColors.primary,
            ),
          ),

          // Lista de categorías
          Expanded(
            child: BlocConsumer<CategoryManagementBloc, CategoryManagementState>(
              listener: (context, state) {
                if (state is CategoryManagementError) {
                  AppLogger.error('Error loading categories',
                      tag: 'CategoriesManagementPage', error: state.message);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is CategoryManagementLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CategoriesWithUsageLoaded) {
                  final categories = state.categories;

                  if (categories.isEmpty) {
                    return _buildEmptyState();
                  }

                  AppLogger.info('Displaying ${categories.length} categories',
                      tag: 'CategoriesManagementPage');

                  return RefreshIndicator(
                    onRefresh: () async {
                      _loadCategories();
                    },
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final categoryWithUsage = categories[index];
                        return CategoryWithUsageListItem(
                          categoryWithUsage: categoryWithUsage,
                          onTap: () => _navigateToEdit(categoryWithUsage.category.id),
                          onEdit: () => _navigateToEdit(categoryWithUsage.category.id),
                          onDelete: () => _confirmDelete(categoryWithUsage),
                        );
                      },
                    ),
                  );
                }

                if (state is CategorySearchResults) {
                  final categories = state.results;

                  if (categories.isEmpty) {
                    return _buildEmptySearchState(state.query);
                  }

                  AppLogger.info('Search results: ${categories.length} categories',
                      tag: 'CategoriesManagementPage');

                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryListItemWidget(
                        category: category,
                        onTap: () => _navigateToEdit(category.id),
                        onEdit: () => _navigateToEdit(category.id),
                        onDelete: () => _showDeleteValidation(category.id),
                      );
                    },
                  );
                }

                return _buildEmptyState();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreate,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Categoría'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay categorías',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primera categoría personalizada',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _navigateToCreate,
            icon: const Icon(Icons.add),
            label: const Text('Crear Categoría'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin resultados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No se encontraron categorías para "$query"',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToCreate() async {
    AppLogger.info('Navigating to create category', tag: 'CategoriesManagementPage');
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => context.read<CategoryBloc>(),
          child: const CategoryFormPage(),
        ),
      ),
    );

    if (result == true) {
      AppLogger.info('Category created, reloading list', tag: 'CategoriesManagementPage');
      _loadCategories();
    }
  }

  void _navigateToEdit(String categoryId) async {
    AppLogger.info('Navigating to edit category: $categoryId', tag: 'CategoriesManagementPage');
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => context.read<CategoryBloc>(),
          child: CategoryFormPage(categoryId: categoryId),
        ),
      ),
    );

    if (result == true) {
      AppLogger.info('Category updated, reloading list', tag: 'CategoriesManagementPage');
      _loadCategories();
    }
  }

  void _showDeleteValidation(String categoryId) {
    AppLogger.info('Validating deletion for category: $categoryId', tag: 'CategoriesManagementPage');
    context.read<CategoryManagementBloc>().add(
          ValidateCategoryDeletionRequested(categoryId),
        );

    showDialog(
      context: context,
      builder: (dialogContext) => BlocListener<CategoryManagementBloc,
          CategoryManagementState>(
        listener: (context, state) {
          if (state is CategoryDeletionValidated) {
            Navigator.of(dialogContext).pop();
            if (state.validationResult.canDelete) {
              _confirmDelete(null, categoryId: categoryId);
            } else {
              _showCannotDeleteDialog(state.validationResult.reason);
            }
          }
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _confirmDelete(categoryWithUsage, {String? categoryId}) {
    final canDelete =
        categoryWithUsage?.canBeDeleted ?? true;
    final name = categoryWithUsage?.category.name ?? 'esta categoría';

    if (!canDelete) {
      _showCannotDeleteDialog(
        'La categoría tiene transacciones o subcategorías asociadas',
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content: Text('¿Estás seguro de que deseas eliminar "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCategory(categoryId ?? categoryWithUsage.category.id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(String categoryId) {
    AppLogger.info('Deleting category: $categoryId', tag: 'CategoriesManagementPage');
    context.read<CategoryBloc>().add(DeleteCategoryRequested(categoryId: categoryId));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Categoría eliminada')),
    );

    _loadCategories();
  }

  void _showCannotDeleteDialog(String? reason) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No se puede eliminar'),
        content: Text(reason ?? 'Esta categoría no puede ser eliminada'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
