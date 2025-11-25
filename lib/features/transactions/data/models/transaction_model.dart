import '../../domain/entities/transaction.dart' as domain;

/// Modelo de Transacción para la capa de datos
class TransactionModel extends domain.Transaction {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.categoryId,
    required super.type,
    required super.amount,
    super.description,
    super.notes,
    required super.date,
    super.attachmentUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Crea un TransactionModel desde JSON de Supabase
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      date: DateTime.parse(json['date'] as String),
      attachmentUrl: json['attachment_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convierte el modelo a JSON para Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'type': type,
      'amount': amount,
      'description': description,
      'notes': notes,
      'date': date.toIso8601String().split('T')[0],
      'attachment_url': attachmentUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Convierte el modelo a JSON para insertar
  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'category_id': categoryId,
      'type': type,
      'amount': amount,
      'description': description,
      'notes': notes,
      'date': date.toIso8601String().split('T')[0],
      'attachment_url': attachmentUrl,
    };
  }

  /// Convierte el modelo a JSON para actualizar
  Map<String, dynamic> toUpdateJson() {
    return {
      'category_id': categoryId,
      'type': type,
      'amount': amount,
      'description': description,
      'notes': notes,
      'date': date.toIso8601String().split('T')[0],
      'attachment_url': attachmentUrl,
    };
  }
}
