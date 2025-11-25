import 'package:equatable/equatable.dart';
import 'category.dart';

/// Entidad que extiende Category con información de uso
/// Útil para mostrar metadata en la UI sin múltiples queries
class CategoryWithUsage extends Equatable {
  final Category category;
  final int transactionCount;
  final double totalAmount;
  final bool canBeDeleted;
  final List<Category> subcategories;

  const CategoryWithUsage({
    required this.category,
    required this.transactionCount,
    required this.totalAmount,
    required this.canBeDeleted,
    required this.subcategories,
  });

  @override
  List<Object?> get props => [
        category,
        transactionCount,
        totalAmount,
        canBeDeleted,
        subcategories,
      ];
}
