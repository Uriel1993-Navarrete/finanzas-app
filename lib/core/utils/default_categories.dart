import 'package:uuid/uuid.dart';
import '../../features/categories/domain/entities/category.dart';

/// Categorías predeterminadas para nuevos usuarios
class DefaultCategories {
  static final _uuid = Uuid();

  /// Genera categorías de ingresos predeterminadas
  static List<Category> getDefaultIncomeCategories(String userId) {
    final now = DateTime.now();

    return [
      Category(
        id: _uuid.v4(),
        name: 'Salario',
        description: 'Ingreso por trabajo',
        icon: 'work',
        color: '#00D9A5',
        type: 'income',
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _uuid.v4(),
        name: 'Freelance',
        description: 'Trabajos independientes',
        icon: 'laptop',
        color: '#4D9FFF',
        type: 'income',
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _uuid.v4(),
        name: 'Inversiones',
        description: 'Rendimientos de inversiones',
        icon: 'trending_up',
        color: '#6C63FF',
        type: 'income',
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _uuid.v4(),
        name: 'Bonos',
        description: 'Bonificaciones y premios',
        icon: 'card_giftcard',
        color: '#FFB84D',
        type: 'income',
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _uuid.v4(),
        name: 'Otros Ingresos',
        description: 'Otros tipos de ingresos',
        icon: 'add_circle',
        color: '#9C27B0',
        type: 'income',
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  /// Genera categorías de gastos predeterminadas con subcategorías
  static List<Category> getDefaultExpenseCategories(String userId) {
    final now = DateTime.now();

    return [
      // Alimentación
      Category(
        id: _uuid.v4(),
        name: 'Alimentación',
        description: 'Gastos en comida y bebida',
        icon: 'restaurant',
        color: '#FF6584',
        type: 'expense',
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),

      // Transporte
      Category(
        id: _uuid.v4(),
        name: 'Transporte',
        description: 'Gastos de movilidad',
        icon: 'directions_car',
        color: '#FF9800',
        type: 'expense',
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),

      // Vivienda
      Category(
        id: _uuid.v4(),
        name: 'Vivienda',
        description: 'Renta, hipoteca y servicios',
        icon: 'home',
        color: '#2196F3',
        type: 'expense',
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),

      // Entretenimiento
      Category(
        id: _uuid.v4(),
        name: 'Entretenimiento',
        description: 'Ocio y diversión',
        icon: 'movie',
        color: '#E91E63',
        type: 'expense',
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),

      // Salud
      Category(
        id: _uuid.v4(),
        name: 'Salud',
        description: 'Medicina y cuidado personal',
        icon: 'local_hospital',
        color: '#4CAF50',
        type: 'expense',
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),

      // Educación
      Category(
        id: _uuid.v4(),
        name: 'Educación',
        description: 'Cursos, libros y formación',
        icon: 'school',
        color: '#9C27B0',
        type: 'expense',
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),

      // Compras
      Category(
        id: _uuid.v4(),
        name: 'Compras',
        description: 'Ropa, tecnología y otros',
        icon: 'shopping_bag',
        color: '#FF5722',
        type: 'expense',
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),

      // Servicios
      Category(
        id: _uuid.v4(),
        name: 'Servicios',
        description: 'Suscripciones y servicios',
        icon: 'subscriptions',
        color: '#00BCD4',
        type: 'expense',
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),

      // Otros Gastos
      Category(
        id: _uuid.v4(),
        name: 'Otros Gastos',
        description: 'Gastos varios',
        icon: 'more_horiz',
        color: '#607D8B',
        type: 'expense',
        userId: userId,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  /// Obtiene todas las categorías predeterminadas
  static List<Category> getAllDefaultCategories(String userId) {
    return [
      ...getDefaultIncomeCategories(userId),
      ...getDefaultExpenseCategories(userId),
    ];
  }
}
