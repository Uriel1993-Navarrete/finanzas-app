import 'package:equatable/equatable.dart';

/// Entidad de Transacción
class Transaction extends Equatable {
  final String id;
  final String userId;
  final String categoryId;
  final String type; // 'income' o 'expense'
  final double amount;
  final String? description;
  final String? notes;
  final DateTime date;
  final String? attachmentUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Transaction({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.type,
    required this.amount,
    this.description,
    this.notes,
    required this.date,
    this.attachmentUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Verifica si es un ingreso
  bool get isIncome => type == 'income';

  /// Verifica si es un egreso
  bool get isExpense => type == 'expense';

  /// Copia la entidad con nuevos valores
  Transaction copyWith({
    String? id,
    String? userId,
    String? categoryId,
    String? type,
    double? amount,
    String? description,
    String? notes,
    DateTime? date,
    String? attachmentUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        categoryId,
        type,
        amount,
        description,
        notes,
        date,
        attachmentUrl,
        createdAt,
        updatedAt,
      ];
}
