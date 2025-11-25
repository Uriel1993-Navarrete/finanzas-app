import '../../domain/entities/category.dart';

/// Modelo de Categoría para la capa de datos
class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.description,
    required super.icon,
    required super.color,
    required super.type,
    super.parentId,
    required super.userId,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Crea un CategoryModel desde JSON de Supabase
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String,
      color: json['color'] as String,
      type: json['type'] as String,
      parentId: json['parent_id'] as String?,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convierte el modelo a JSON para Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'type': type,
      'parent_id': parentId,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Convierte el modelo a JSON para insertar (sin id, created_at, updated_at)
  Map<String, dynamic> toInsertJson() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'type': type,
      'parent_id': parentId,
      'user_id': userId,
    };
  }

  /// Convierte el modelo a JSON para actualizar
  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'type': type,
      'parent_id': parentId,
    };
  }
}
