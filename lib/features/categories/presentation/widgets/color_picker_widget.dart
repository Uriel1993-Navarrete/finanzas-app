import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Widget para seleccionar un color de categoría
/// Muestra un grid scrollable con la paleta de colores disponibles
///
/// Uso:
/// ```dart
/// ColorPickerWidget(
///   selectedColor: Colors.blue,
///   onColorSelected: (color) {
///     setState(() => _selectedColor = color);
///   },
/// )
/// ```
class ColorPickerWidget extends StatelessWidget {
  /// Color actualmente seleccionado
  final Color? selectedColor;

  /// Callback cuando se selecciona un color
  final ValueChanged<Color> onColorSelected;

  /// Número de columnas en el grid
  final int crossAxisCount;

  const ColorPickerWidget({
    super.key,
    this.selectedColor,
    required this.onColorSelected,
    this.crossAxisCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.palette, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(
                'Selecciona un color',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),

        // Colors grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: AppColors.categoryColorPalette.length,
            itemBuilder: (context, index) {
              final color = AppColors.categoryColorPalette[index];
              final isSelected = selectedColor != null &&
                  color.value == selectedColor!.value;

              return _ColorItem(
                color: color,
                isSelected: isSelected,
                onTap: () => onColorSelected(color),
              );
            },
          ),
        ),

        // Footer con conteo
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${AppColors.categoryColorPalette.length} colores disponibles',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget individual para cada color en el grid
class _ColorItem extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorItem({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.textPrimary : Colors.transparent,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: isSelected ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isSelected
              ? const Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

/// Dialog que envuelve el ColorPickerWidget para uso rápido
class ColorPickerDialog extends StatelessWidget {
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerDialog({
    super.key,
    this.selectedColor,
    required this.onColorSelected,
  });

  /// Muestra el dialog y retorna el color seleccionado
  static Future<Color?> show({
    required BuildContext context,
    Color? selectedColor,
  }) async {
    return showDialog<Color>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: ColorPickerWidget(
            selectedColor: selectedColor,
            onColorSelected: (color) {
              Navigator.of(context).pop(color);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: ColorPickerWidget(
          selectedColor: selectedColor,
          onColorSelected: (color) {
            onColorSelected(color);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

/// Widget compacto para mostrar el color seleccionado con opción de cambio
class ColorSelectorButton extends StatelessWidget {
  /// Color actualmente seleccionado
  final Color selectedColor;

  /// Callback cuando se selecciona un nuevo color
  final ValueChanged<Color> onColorSelected;

  /// Texto del label
  final String label;

  const ColorSelectorButton({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.label = 'Color',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final newColor = await ColorPickerDialog.show(
          context: context,
          selectedColor: selectedColor,
        );
        if (newColor != null) {
          onColorSelected(newColor);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Color preview
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.border,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: selectedColor.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Label and hex code
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppColors.toHex(selectedColor).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            // Change icon
            const Icon(
              Icons.edit,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
