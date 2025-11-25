import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/debouncer.dart';

/// Widget de barra de búsqueda con debouncer integrado
/// Previene múltiples llamadas innecesarias durante la escritura
///
/// Uso:
/// ```dart
/// SearchBarWidget(
///   hintText: 'Buscar categorías...',
///   onSearchChanged: (query) {
///     // Esta función se ejecuta después del debounce
///     searchCategories(query);
///   },
///   debounceDuration: Duration(milliseconds: 500),
/// )
/// ```
class SearchBarWidget extends StatefulWidget {
  /// Texto del placeholder
  final String hintText;

  /// Callback cuando cambia el texto de búsqueda (después del debounce)
  final ValueChanged<String> onSearchChanged;

  /// Duración del debounce (default: 500ms)
  final Duration debounceDuration;

  /// Controller externo opcional
  final TextEditingController? controller;

  /// Si true, muestra botón para limpiar
  final bool showClearButton;

  /// Icono de prefijo
  final IconData? prefixIcon;

  /// Color del acento
  final Color? accentColor;

  /// Callback cuando se presiona el botón de búsqueda
  final VoidCallback? onSearchPressed;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Buscar...',
    required this.onSearchChanged,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.controller,
    this.showClearButton = true,
    this.prefixIcon,
    this.accentColor,
    this.onSearchPressed,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  late Debouncer _debouncer;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _debouncer = Debouncer(duration: widget.debounceDuration);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _showClear) {
      setState(() => _showClear = hasText);
    }

    // Ejecutar búsqueda con debounce
    _debouncer.run(() {
      widget.onSearchChanged(_controller.text);
    });
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.accentColor ?? AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
          ),
          prefixIcon: Icon(
            widget.prefixIcon ?? Icons.search,
            color: accentColor,
          ),
          suffixIcon: _buildSuffixIcon(),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: widget.onSearchPressed != null
            ? (_) => widget.onSearchPressed!()
            : null,
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (!widget.showClearButton || !_showClear) {
      return null;
    }

    return IconButton(
      icon: const Icon(Icons.clear),
      onPressed: _clearSearch,
      color: AppColors.textSecondary,
      tooltip: 'Limpiar búsqueda',
    );
  }
}

/// Versión compacta del SearchBar para uso en listas
class CompactSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onSearchChanged;
  final Duration debounceDuration;
  final Color? accentColor;

  const CompactSearchBar({
    super.key,
    this.hintText = 'Buscar...',
    required this.onSearchChanged,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBarWidget(
      hintText: hintText,
      onSearchChanged: onSearchChanged,
      debounceDuration: debounceDuration,
      accentColor: accentColor,
      showClearButton: true,
      prefixIcon: Icons.search,
    );
  }
}

/// SearchBar con filtros adicionales
class SearchBarWithFilters extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onSearchChanged;
  final List<SearchFilter> filters;
  final ValueChanged<List<String>>? onFiltersChanged;
  final Duration debounceDuration;

  const SearchBarWithFilters({
    super.key,
    this.hintText = 'Buscar...',
    required this.onSearchChanged,
    required this.filters,
    this.onFiltersChanged,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<SearchBarWithFilters> createState() => _SearchBarWithFiltersState();
}

class _SearchBarWithFiltersState extends State<SearchBarWithFilters> {
  final Set<String> _activeFilters = {};

  void _toggleFilter(String filterId) {
    setState(() {
      if (_activeFilters.contains(filterId)) {
        _activeFilters.remove(filterId);
      } else {
        _activeFilters.add(filterId);
      }
      widget.onFiltersChanged?.call(_activeFilters.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchBarWidget(
          hintText: widget.hintText,
          onSearchChanged: widget.onSearchChanged,
          debounceDuration: widget.debounceDuration,
        ),
        if (widget.filters.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.filters.map((filter) {
              final isActive = _activeFilters.contains(filter.id);
              return FilterChip(
                label: Text(filter.label),
                selected: isActive,
                onSelected: (_) => _toggleFilter(filter.id),
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isActive ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

/// Modelo para filtros de búsqueda
class SearchFilter {
  final String id;
  final String label;
  final IconData? icon;

  const SearchFilter({
    required this.id,
    required this.label,
    this.icon,
  });
}
