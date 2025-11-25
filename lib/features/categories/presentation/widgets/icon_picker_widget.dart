import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/category_icons.dart';

/// Widget para seleccionar un icono de categoría
/// Muestra un grid scrollable con todos los iconos disponibles
///
/// Uso:
/// ```dart
/// IconPickerWidget(
///   selectedIcon: 'restaurant',
///   onIconSelected: (iconName) {
///     setState(() => _selectedIcon = iconName);
///   },
/// )
/// ```
class IconPickerWidget extends StatefulWidget {
  /// Nombre del icono actualmente seleccionado
  final String? selectedIcon;

  /// Callback cuando se selecciona un icono
  final ValueChanged<String> onIconSelected;

  /// Color del tema para el icono seleccionado
  final Color? accentColor;

  /// Si true, muestra barra de búsqueda
  final bool showSearch;

  const IconPickerWidget({
    super.key,
    this.selectedIcon,
    required this.onIconSelected,
    this.accentColor,
    this.showSearch = false,
  });

  @override
  State<IconPickerWidget> createState() => _IconPickerWidgetState();
}

class _IconPickerWidgetState extends State<IconPickerWidget> {
  late List<String> _displayedIcons;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _displayedIcons = CategoryIcons.getAllIconNames();
  }

  void _filterIcons(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _displayedIcons = CategoryIcons.getAllIconNames();
      } else {
        _displayedIcons = CategoryIcons.getAllIconNames()
            .where((iconName) => iconName.toLowerCase().contains(_searchQuery))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.accentColor ?? AppColors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.palette, color: accentColor),
              const SizedBox(width: 12),
              Text(
                'Selecciona un icono',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),

        // Search bar (opcional)
        if (widget.showSearch)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar icono...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.surfaceVariant,
              ),
              onChanged: _filterIcons,
            ),
          ),

        const SizedBox(height: 16),

        // Icons grid
        Expanded(
          child: _displayedIcons.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron iconos',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: _displayedIcons.length,
                  itemBuilder: (context, index) {
                    final iconName = _displayedIcons[index];
                    final isSelected = iconName == widget.selectedIcon;

                    return _IconItem(
                      iconName: iconName,
                      isSelected: isSelected,
                      accentColor: accentColor,
                      onTap: () => widget.onIconSelected(iconName),
                    );
                  },
                ),
        ),

        // Footer con conteo
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${_displayedIcons.length} iconos disponibles',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget individual para cada icono en el grid
class _IconItem extends StatelessWidget {
  final String iconName;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _IconItem({
    required this.iconName,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? accentColor.withOpacity(0.1) : AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? accentColor : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Icon(
              CategoryIcons.getIcon(iconName),
              size: 28,
              color: isSelected ? accentColor : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Dialog que envuelve el IconPickerWidget para uso rápido
class IconPickerDialog extends StatelessWidget {
  final String? selectedIcon;
  final ValueChanged<String> onIconSelected;
  final Color? accentColor;

  const IconPickerDialog({
    super.key,
    this.selectedIcon,
    required this.onIconSelected,
    this.accentColor,
  });

  /// Muestra el dialog y retorna el icono seleccionado
  static Future<String?> show({
    required BuildContext context,
    String? selectedIcon,
    Color? accentColor,
  }) async {
    return showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          child: IconPickerWidget(
            selectedIcon: selectedIcon,
            onIconSelected: (iconName) {
              Navigator.of(context).pop(iconName);
            },
            accentColor: accentColor,
            showSearch: true,
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
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        child: IconPickerWidget(
          selectedIcon: selectedIcon,
          onIconSelected: (iconName) {
            onIconSelected(iconName);
            Navigator.of(context).pop();
          },
          accentColor: accentColor,
          showSearch: true,
        ),
      ),
    );
  }
}
