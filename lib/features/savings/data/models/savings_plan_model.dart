import '../../domain/entities/savings_plan.dart';

/// Modelo de Plan de Ahorro (extiende la entidad y agrega serialización)
class SavingsPlanModel extends SavingsPlan {
  const SavingsPlanModel({
    required super.id,
    required super.userId,
    required super.name,
    super.description,
    required super.targetAmount,
    required super.currentAmount,
    required super.startDate,
    super.targetDate,
    required super.status,
    super.icon,
    super.color,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Crea un modelo desde JSON (Supabase)
  factory SavingsPlanModel.fromJson(Map<String, dynamic> json) {
    return SavingsPlanModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      targetAmount: (json['target_amount'] as num).toDouble(),
      currentAmount: (json['current_amount'] as num).toDouble(),
      startDate: DateTime.parse(json['start_date'] as String),
      targetDate: json['target_date'] != null
          ? DateTime.parse(json['target_date'] as String)
          : null,
      status: json['status'] as String,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convierte el modelo a JSON (para Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
      'start_date': startDate.toIso8601String().split('T')[0], // Solo fecha
      'target_date': targetDate?.toIso8601String().split('T')[0],
      'status': status,
      'icon': icon,
      'color': color,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Crea un modelo desde una entidad
  factory SavingsPlanModel.fromEntity(SavingsPlan savingsPlan) {
    return SavingsPlanModel(
      id: savingsPlan.id,
      userId: savingsPlan.userId,
      name: savingsPlan.name,
      description: savingsPlan.description,
      targetAmount: savingsPlan.targetAmount,
      currentAmount: savingsPlan.currentAmount,
      startDate: savingsPlan.startDate,
      targetDate: savingsPlan.targetDate,
      status: savingsPlan.status,
      icon: savingsPlan.icon,
      color: savingsPlan.color,
      createdAt: savingsPlan.createdAt,
      updatedAt: savingsPlan.updatedAt,
    );
  }

  /// Copia el modelo con nuevos valores
  @override
  SavingsPlanModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    double? targetAmount,
    double? currentAmount,
    DateTime? startDate,
    DateTime? targetDate,
    String? status,
    String? icon,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SavingsPlanModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      status: status ?? this.status,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
