import '../../domain/entities/category_with_usage.dart';
import 'category_model.dart';

/// Modelo de CategoryWithUsage para la capa de datos
class CategoryWithUsageModel extends CategoryWithUsage {
  const CategoryWithUsageModel({
    required super.category,
    required super.transactionCount,
    required super.totalAmount,
    required super.canBeDeleted,
    required super.subcategories,
  });

  /// Crea un CategoryWithUsageModel desde datos de Supabase
  ///
  /// Este método asume que los datos vienen de múltiples queries:
  /// - categoryJson: datos de la categoría principal
  /// - transactionCount: contador de transacciones
  /// - totalAmount: suma total de transacciones
  /// - subcategoriesJson: lista de subcategorías
  factory CategoryWithUsageModel.fromData({
    required Map<String, dynamic> categoryJson,
    required int transactionCount,
    required double totalAmount,
    required List<Map<String, dynamic>> subcategoriesJson,
  }) {
    final category = CategoryModel.fromJson(categoryJson);
    final subcategories = subcategoriesJson
        .map((json) => CategoryModel.fromJson(json))
        .toList();

    // Una categoría puede ser eliminada si:
    // 1. No tiene transacciones asociadas
    // 2. No tiene subcategorías
    final canBeDeleted = transactionCount == 0 && subcategories.isEmpty;

    return CategoryWithUsageModel(
      category: category,
      transactionCount: transactionCount,
      totalAmount: totalAmount,
      canBeDeleted: canBeDeleted,
      subcategories: subcategories,
    );
  }

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'category': (category as CategoryModel).toJson(),
      'transaction_count': transactionCount,
      'total_amount': totalAmount,
      'can_be_deleted': canBeDeleted,
      'subcategories': subcategories
          .map((cat) => (cat as CategoryModel).toJson())
          .toList(),
    };
  }
}
