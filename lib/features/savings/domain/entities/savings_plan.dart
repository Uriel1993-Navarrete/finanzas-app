import 'package:equatable/equatable.dart';

/// Entidad de Plan de Ahorro
class SavingsPlan extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final double targetAmount;
  final double currentAmount;
  final DateTime startDate;
  final DateTime? targetDate;
  final String status; // 'active', 'completed', 'cancelled'
  final String? icon;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SavingsPlan({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.startDate,
    this.targetDate,
    required this.status,
    this.icon,
    this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calcula el progreso del plan (0.0 a 1.0)
  double get progress {
    if (targetAmount <= 0) return 0.0;
    final prog = currentAmount / targetAmount;
    return prog > 1.0 ? 1.0 : prog;
  }

  /// Calcula el porcentaje de progreso (0 a 100)
  double get progressPercentage => progress * 100;

  /// Cantidad restante para alcanzar la meta
  double get remainingAmount {
    final remaining = targetAmount - currentAmount;
    return remaining > 0 ? remaining : 0;
  }

  /// Verifica si el plan está completo
  bool get isCompleted => currentAmount >= targetAmount || status == 'completed';

  /// Verifica si el plan está activo
  bool get isActive => status == 'active';

  /// Verifica si el plan está cancelado
  bool get isCancelled => status == 'cancelled';

  /// Días restantes hasta la fecha objetivo (si existe)
  int? get daysRemaining {
    if (targetDate == null) return null;
    final now = DateTime.now();
    final difference = targetDate!.difference(now);
    return difference.inDays;
  }

  /// Verifica si la fecha objetivo ha pasado
  bool get isOverdue {
    if (targetDate == null) return false;
    final now = DateTime.now();
    return targetDate!.isBefore(now) && !isCompleted;
  }

  /// Cantidad sugerida de ahorro diario para alcanzar la meta
  double? get suggestedDailySaving {
    if (targetDate == null || daysRemaining == null || daysRemaining! <= 0) {
      return null;
    }
    return remainingAmount / daysRemaining!;
  }

  /// Cantidad sugerida de ahorro mensual para alcanzar la meta
  double? get suggestedMonthlySaving {
    if (targetDate == null || daysRemaining == null || daysRemaining! <= 0) {
      return null;
    }
    final monthsRemaining = daysRemaining! / 30;
    return monthsRemaining > 0 ? remainingAmount / monthsRemaining : null;
  }

  /// Copia la entidad con nuevos valores
  SavingsPlan copyWith({
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
    return SavingsPlan(
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

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        description,
        targetAmount,
        currentAmount,
        startDate,
        targetDate,
        status,
        icon,
        color,
        createdAt,
        updatedAt,
      ];
}
