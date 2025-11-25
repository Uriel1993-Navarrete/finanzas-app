import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';

/// Data Source remoto de categorías
abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories(String userId);
  Future<List<CategoryModel>> getCategoriesByType(String userId, String type);
  Future<CategoryModel> getCategoryById(String id);
  Future<CategoryModel> createCategory(CategoryModel category);
  Future<CategoryModel> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
  Future<List<CategoryModel>> getSubcategories(String parentId);
}

/// Implementación del Data Source remoto con Supabase
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final SupabaseClient supabaseClient;

  CategoryRemoteDataSourceImpl({required this.supabaseClient});

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
}
