import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/category_icons.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/category_with_usage.dart';

/// Widget para mostrar un item de categoría en una lista
/// Soporta acciones de swipe y tap
///
/// Uso:
/// ```dart
/// CategoryListItemWidget(
///   category: category,
///   onTap: () => navigateToEdit(category),
///   onEdit: () => showEditDialog(category),
///   onDelete: () => confirmDelete(category),
/// )
/// ```
class CategoryListItemWidget extends StatelessWidget {
  /// Categoría a mostrar
  final Category category;

  /// Callback cuando se toca el item
  final VoidCallback? onTap;

  /// Callback para editar
  final VoidCallback? onEdit;

  /// Callback para eliminar
  final VoidCallback? onDelete;

  /// Si true, muestra el subtítulo con tipo
  final bool showType;

  /// Si true, muestra indicador de subcategoría
  final bool showSubcategoryIndicator;

  /// Si true, habilita acciones de swipe
  final bool enableSwipe;

  const CategoryListItemWidget({
    super.key,
    required this.category,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showType = true,
    this.showSubcategoryIndicator = true,
    this.enableSwipe = true,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppColors.fromHex(category.color);
    final categoryIcon = CategoryIcons.getIcon(category.icon);
    final isSubcategory = category.parentId != null;

    Widget content = Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: _buildLeadingIcon(categoryIcon, categoryColor),
        title: Row(
          children: [
            if (isSubcategory && showSubcategoryIndicator) ...[
              Icon(
                Icons.subdirectory_arrow_right,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Text(
                category.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        subtitle: showType
            ? Text(
                category.type == 'income' ? 'Ingreso' : 'Gasto',
                style: TextStyle(
                  color: category.type == 'income'
                      ? AppColors.income
                      : AppColors.expense,
                  fontSize: 13,
                ),
              )
            : null,
        trailing: onEdit != null || onDelete != null
            ? PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'edit' && onEdit != null) {
                    onEdit!();
                  } else if (value == 'delete' && onDelete != null) {
                    onDelete!();
                  }
                },
                itemBuilder: (context) => [
                  if (onEdit != null)
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 12),
                          Text('Editar'),
                        ],
                      ),
                    ),
                  if (onDelete != null)
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: AppColors.error),
                          SizedBox(width: 12),
                          Text(
                            'Eliminar',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                ],
              )
            : null,
        onTap: onTap,
      ),
    );

    // Wrap with dismissible if swipe is enabled
    if (enableSwipe && onDelete != null) {
      content = Dismissible(
        key: ValueKey(category.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          return await _showDeleteConfirmation(context);
        },
        onDismissed: (_) => onDelete!(),
        background: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 28,
          ),
        ),
        child: content,
      );
    }

    return content;
  }

  Widget _buildLeadingIcon(IconData icon, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${category.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

/// Widget para mostrar categoría con información de uso
class CategoryWithUsageListItem extends StatelessWidget {
  final CategoryWithUsage categoryWithUsage;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CategoryWithUsageListItem({
    super.key,
    required this.categoryWithUsage,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final category = categoryWithUsage.category;
    final categoryColor = AppColors.fromHex(category.color);
    final categoryIcon = CategoryIcons.getIcon(category.icon);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${categoryWithUsage.transactionCount} transacciones',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (categoryWithUsage.subcategories.isNotEmpty) ...[
                          Icon(
                            Icons.folder,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${categoryWithUsage.subcategories.length}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit' && onEdit != null) {
                      onEdit!();
                    } else if (value == 'delete' && onDelete != null) {
                      onDelete!();
                    }
                  },
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 12),
                            Text('Editar'),
                          ],
                        ),
                      ),
                    if (onDelete != null)
                      PopupMenuItem(
                        value: 'delete',
                        enabled: categoryWithUsage.canBeDeleted,
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              size: 20,
                              color: categoryWithUsage.canBeDeleted
                                  ? AppColors.error
                                  : AppColors.textDisabled,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Eliminar',
                              style: TextStyle(
                                color: categoryWithUsage.canBeDeleted
                                    ? AppColors.error
                                    : AppColors.textDisabled,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
