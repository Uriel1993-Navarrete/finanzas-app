import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/category_icons.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/category_bloc.dart';
import '../../domain/entities/category.dart';
import '../widgets/color_picker_widget.dart';
import '../widgets/icon_picker_widget.dart';

/// Formulario para crear o editar una categoría
class CategoryFormPage extends StatefulWidget {
  /// ID de la categoría a editar (null si es creación)
  final String? categoryId;

  const CategoryFormPage({super.key, this.categoryId});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String? _selectedType = 'expense'; // Por defecto gasto
  String _selectedIcon = 'category';
  Color _selectedColor = AppColors.primary;
  bool _isLoading = false;
  Category? _originalCategory;

  bool get _isEditing => widget.categoryId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      AppLogger.info('Loading category for edit: ${widget.categoryId}', tag: 'CategoryFormPage');
      _loadCategory();
    } else {
      AppLogger.info('Creating new category', tag: 'CategoryFormPage');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _loadCategory() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<CategoryBloc>().add(
            LoadCategoriesRequested(userId: authState.user.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Categoría' : 'Nueva Categoría'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryOperationSuccess) {
            AppLogger.info(
                _isEditing ? 'Category updated successfully' : 'Category created successfully',
                tag: 'CategoryFormPage');
            Navigator.of(context).pop(true);
          }

          if (state is CategoryError) {
            AppLogger.error('Category operation failed',
                tag: 'CategoryFormPage', error: state.message);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
            setState(() => _isLoading = false);
          }

          if (state is CategoriesLoaded && _isEditing && _originalCategory == null) {
            final category = state.categories
                .firstWhere((c) => c.id == widget.categoryId);
            _loadCategoryData(category);
          }
        },
        builder: (context, state) {
          if (_isEditing && _originalCategory == null && state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preview de la categoría
                  _buildPreviewCard(),
                  const SizedBox(height: 24),

                  // Nombre
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de la categoría *',
                      hintText: 'Ej: Restaurantes, Transporte, Salario',
                      prefixIcon: const Icon(Icons.label),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es requerido';
                      }
                      if (value.length < 3) {
                        return 'Mínimo 3 caracteres';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // Tipo
                  Text(
                    'Tipo *',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeOption(
                          'income',
                          'Ingreso',
                          Icons.trending_up,
                          AppColors.income,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTypeOption(
                          'expense',
                          'Gasto',
                          Icons.trending_down,
                          AppColors.expense,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Icono
                  Text(
                    'Icono *',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _showIconPicker,
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
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: _selectedColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              CategoryIcons.getIcon(_selectedIcon),
                              color: _selectedColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selecciona un icono',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Toca para cambiar',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.edit, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Color
                  Text(
                    'Color *',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ColorSelectorButton(
                    selectedColor: _selectedColor,
                    onColorSelected: (color) {
                      setState(() => _selectedColor = color);
                      AppLogger.info('Color changed to: ${AppColors.toHex(color)}',
                          tag: 'CategoryFormPage');
                    },
                    label: 'Color de la categoría',
                  ),
                  const SizedBox(height: 32),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveCategory,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(_isEditing ? 'Actualizar' : 'Crear'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _selectedColor,
            _selectedColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _selectedColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              CategoryIcons.getIcon(_selectedIcon),
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nameController.text.isEmpty
                      ? 'Vista previa'
                      : _nameController.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedType == 'income' ? 'Ingreso' : 'Gasto',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(String value, String label, IconData icon, Color color) {
    final isSelected = _selectedType == value;
    return InkWell(
      onTap: () {
        setState(() => _selectedType = value);
        AppLogger.info('Type changed to: $value', tag: 'CategoryFormPage');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showIconPicker() async {
    AppLogger.info('Opening icon picker', tag: 'CategoryFormPage');
    final icon = await IconPickerDialog.show(
      context: context,
      selectedIcon: _selectedIcon,
      accentColor: _selectedColor,
    );

    if (icon != null) {
      setState(() => _selectedIcon = icon);
      AppLogger.info('Icon changed to: $icon', tag: 'CategoryFormPage');
    }
  }

  void _loadCategoryData(Category category) {
    AppLogger.info('Loading existing category data: ${category.id}', tag: 'CategoryFormPage');
    setState(() {
      _originalCategory = category;
      _nameController.text = category.name;
      _selectedType = category.type;
      _selectedIcon = category.icon;
      _selectedColor = AppColors.fromHex(category.color);
    });
  }

  void _saveCategory() {
    if (!_formKey.currentState!.validate()) {
      AppLogger.warning('Form validation failed', tag: 'CategoryFormPage');
      return;
    }

    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un tipo')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      AppLogger.error('User not authenticated', tag: 'CategoryFormPage');
      return;
    }

    final colorHex = AppColors.toHex(_selectedColor);
    final now = DateTime.now();

    if (_isEditing && _originalCategory != null) {
      AppLogger.info('Updating category: ${widget.categoryId}', tag: 'CategoryFormPage');
      final updatedCategory = _originalCategory!.copyWith(
        name: _nameController.text.trim(),
        icon: _selectedIcon,
        color: colorHex,
        updatedAt: now,
      );
      context.read<CategoryBloc>().add(
            UpdateCategoryRequested(category: updatedCategory),
          );
    } else {
      AppLogger.info('Creating new category: ${_nameController.text}', tag: 'CategoryFormPage');
      final newCategory = Category(
        id: '', // Se generará en el backend
        name: _nameController.text.trim(),
        type: _selectedType!,
        icon: _selectedIcon,
        color: colorHex,
        userId: authState.user.id,
        createdAt: now,
        updatedAt: now,
      );
      context.read<CategoryBloc>().add(
            CreateCategoryRequested(category: newCategory),
          );
    }
  }
}
