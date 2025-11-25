import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';
import '../models/category_with_usage_model.dart';
import '../../../transactions/data/datasources/transaction_remote_datasource.dart';

/// Data Source remoto de categorías
abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories(String userId);
  Future<List<CategoryModel>> getCategoriesByType(String userId, String type);
  Future<CategoryModel> getCategoryById(String id);
  Future<CategoryModel> createCategory(CategoryModel category);
  Future<CategoryModel> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
  Future<List<CategoryModel>> getSubcategories(String parentId);

  /// Nuevos métodos para gestión avanzada de categorías
  Future<bool> checkCategoryNameExists(
    String userId,
    String name,
    String type, {
    String? excludeId,
  });
  Future<List<CategoryModel>> searchCategories({
    required String userId,
    required String query,
    String? type,
    bool? isSubcategory,
  });
  Future<CategoryWithUsageModel> getCategoryWithUsage(String categoryId);
}

/// Implementación del Data Source remoto con Supabase
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final SupabaseClient supabaseClient;
  final TransactionRemoteDataSource transactionDataSource;

  CategoryRemoteDataSourceImpl({
    required this.supabaseClient,
    required this.transactionDataSource,
  });

  @override
  Future<List<CategoryModel>> getCategories(String userId) async {
    try {
      final response = await supabaseClient
          .from('categories')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener categorías: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategoriesByType(
    String userId,
    String type,
  ) async {
    try {
      final response = await supabaseClient
          .from('categories')
          .select()
          .eq('user_id', userId)
          .eq('type', type)
          .isFilter('parent_id', null)
          .order('name', ascending: true);

      return (response as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener categorías por tipo: $e');
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    try {
      final response = await supabaseClient
          .from('categories')
          .select()
          .eq('id', id)
          .single();

      return CategoryModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al obtener categoría: $e');
    }
  }

  @override
  Future<CategoryModel> createCategory(CategoryModel category) async {
    try {
      final response = await supabaseClient
          .from('categories')
          .insert(category.toInsertJson())
          .select()
          .single();

      return CategoryModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear categoría: $e');
    }
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    try {
      final response = await supabaseClient
          .from('categories')
          .update(category.toUpdateJson())
          .eq('id', category.id)
          .select()
          .single();

      return CategoryModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar categoría: $e');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await supabaseClient.from('categories').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar categoría: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getSubcategories(String parentId) async {
    try {
      final response = await supabaseClient
          .from('categories')
          .select()
          .eq('parent_id', parentId)
          .order('name', ascending: true);

      return (response as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener subcategorías: $e');
    }
  }

  @override
  Future<bool> checkCategoryNameExists(
    String userId,
    String name,
    String type, {
    String? excludeId,
  }) async {
    try {
      var query = supabaseClient
          .from('categories')
          .select('id')
          .eq('user_id', userId)
          .ilike('name', name)
          .eq('type', type);

      // Excluir la categoría actual si estamos editando
      if (excludeId != null) {
        query = query.neq('id', excludeId);
      }

      final response = await query;
      return (response as List).isNotEmpty;
    } catch (e) {
      throw Exception('Error al verificar nombre de categoría: $e');
    }
  }

  @override
  Future<List<CategoryModel>> searchCategories({
    required String userId,
    required String query,
    String? type,
    bool? isSubcategory,
  }) async {
    try {
      var supabaseQuery = supabaseClient
          .from('categories')
          .select()
          .eq('user_id', userId)
          .ilike('name', '%$query%');

      // Filtrar por tipo si se especifica
      if (type != null) {
        supabaseQuery = supabaseQuery.eq('type', type);
      }

      // Filtrar por subcategoría o categoría principal
      if (isSubcategory != null) {
        if (isSubcategory) {
          supabaseQuery = supabaseQuery.not('parent_id', 'is', null);
        } else {
          supabaseQuery = supabaseQuery.isFilter('parent_id', null);
        }
      }

      final response = await supabaseQuery.order('name', ascending: true);

      return (response as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al buscar categorías: $e');
    }
  }

  @override
  Future<CategoryWithUsageModel> getCategoryWithUsage(String categoryId) async {
    try {
      // 1. Obtener la categoría
      final category = await getCategoryById(categoryId);

      // 2. Obtener subcategorías
      final subcategories = await getSubcategories(categoryId);

      // 3. Obtener el conteo de transacciones
      final transactionCount = await transactionDataSource.getTransactionCount(categoryId);

      // 4. Obtener el total de las transacciones
      final transactionsResponse = await supabaseClient
          .from('transactions')
          .select('amount')
          .eq('category_id', categoryId);

      double totalAmount = 0;
      for (final transaction in transactionsResponse as List) {
        totalAmount += (transaction['amount'] as num).toDouble();
      }

      // 5. Construir el modelo
      return CategoryWithUsageModel.fromData(
        categoryJson: category.toJson(),
        transactionCount: transactionCount,
        totalAmount: totalAmount,
        subcategoriesJson: subcategories.map((cat) => cat.toJson()).toList(),
      );
    } catch (e) {
      throw Exception('Error al obtener categoría con uso: $e');
    }
  }
}
