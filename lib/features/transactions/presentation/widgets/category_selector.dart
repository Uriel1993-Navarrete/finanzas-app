import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../categories/domain/entities/category.dart';

/// Widget selector de categoría
class CategorySelector extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final Function(Category) onSelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categoría',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        if (categories.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No hay categorías disponibles',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((category) {
              final isSelected = selectedCategory?.id == category.id;
              final categoryColor =
                  Color(int.parse('0xFF${category.color.substring(1)}'));

              return GestureDetector(
                onTap: () => onSelected(category),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? categoryColor.withOpacity(0.2)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? categoryColor
                          : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIconData(category.icon),
                        size: 20,
                        color: isSelected
                            ? categoryColor
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        category.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isSelected
                                  ? categoryColor
                                  : AppColors.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  IconData _getIconData(String iconName) {
    // Mapeo de nombres de iconos a IconData
    final iconMap = {
      'work': Icons.work,
      'laptop': Icons.laptop,
      'trending_up': Icons.trending_up,
      'card_giftcard': Icons.card_giftcard,
      'add_circle': Icons.add_circle,
      'restaurant': Icons.restaurant,
      'directions_car': Icons.directions_car,
      'home': Icons.home,
      'movie': Icons.movie,
      'local_hospital': Icons.local_hospital,
      'school': Icons.school,
      'shopping_bag': Icons.shopping_bag,
      'subscriptions': Icons.subscriptions,
      'more_horiz': Icons.more_horiz,
    };

    return iconMap[iconName] ?? Icons.category;
  }
}
