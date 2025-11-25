import 'package:equatable/equatable.dart';

/// Entidad de Categoría
class Category extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String icon;
  final String color;
  final String type; // 'income' o 'expense'
  final String? parentId; // Para subcategorías
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.description,
    required this.icon,
    required this.color,
    required this.type,
    this.parentId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Verifica si es una subcategoría
  bool get isSubcategory => parentId != null;

  /// Copia la entidad con nuevos valores
  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? color,
    String? type,
    String? parentId,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
      parentId: parentId ?? this.parentId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        icon,
        color,
        type,
        parentId,
        userId,
        createdAt,
        updatedAt,
      ];
}
