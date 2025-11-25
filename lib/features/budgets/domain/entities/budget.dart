import 'package:equatable/equatable.dart';

/// Entidad de Presupuesto
class Budget extends Equatable {
  final String id;
  final String userId;
  final String categoryId;
  final double limitAmount;
  final double spentAmount;
  final String period; // 'daily', 'weekly', 'monthly', 'yearly'
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final bool notificationsEnabled;
  final double? warningThreshold; // Porcentaje para alertar (ej: 80.0)
  final DateTime createdAt;
  final DateTime updatedAt;

  const Budget({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.limitAmount,
    required this.spentAmount,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.notificationsEnabled,
    this.warningThreshold,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calcula el porcentaje gastado
  double get spentPercentage {
    if (limitAmount == 0) return 0;
    final percentage = (spentAmount / limitAmount) * 100;
    return percentage > 100 ? 100 : percentage;
  }

  /// Calcula el monto restante
  double get remainingAmount {
    final remaining = limitAmount - spentAmount;
    return remaining > 0 ? remaining : 0;
  }

  /// Verifica si se excedió el presupuesto
  bool get isExceeded => spentAmount > limitAmount;

  /// Verifica si se alcanzó el umbral de advertencia
  bool get shouldWarn {
    if (warningThreshold == null) return false;
    return spentPercentage >= warningThreshold!;
  }

  /// Verifica si el presupuesto está activo en la fecha actual
  bool get isCurrentlyActive {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(endDate);
  }

  /// Copia la entidad con nuevos valores
  Budget copyWith({
    String? id,
    String? userId,
    String? categoryId,
    double? limitAmount,
    double? spentAmount,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    bool? notificationsEnabled,
    double? warningThreshold,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Budget(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      limitAmount: limitAmount ?? this.limitAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      warningThreshold: warningThreshold ?? this.warningThreshold,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        categoryId,
        limitAmount,
        spentAmount,
        period,
        startDate,
        endDate,
        isActive,
        notificationsEnabled,
        warningThreshold,
        createdAt,
        updatedAt,
      ];
}
