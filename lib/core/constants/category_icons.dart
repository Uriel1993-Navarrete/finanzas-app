import 'package:flutter/material.dart';

/// Constantes de iconos para categorías
/// Proporciona mapeo entre nombres de iconos y IconData de Material Icons
class CategoryIcons {
  /// Mapa de todos los iconos disponibles para categorías
  /// Key: nombre del icono (para guardar en BD)
  /// Value: IconData del icono de Material Icons
  static const Map<String, IconData> availableIcons = {
    // Finanzas y dinero
    'money': Icons.attach_money,
    'account_balance': Icons.account_balance,
    'account_balance_wallet': Icons.account_balance_wallet,
    'credit_card': Icons.credit_card,
    'payment': Icons.payment,
    'savings': Icons.savings,
    'currency_exchange': Icons.currency_exchange,
    'payments': Icons.payments,
    'wallet': Icons.wallet,
    'paid': Icons.paid,

    // Comida y bebidas
    'restaurant': Icons.restaurant,
    'fastfood': Icons.fastfood,
    'local_cafe': Icons.local_cafe,
    'local_bar': Icons.local_bar,
    'local_pizza': Icons.local_pizza,
    'lunch_dining': Icons.lunch_dining,
    'dinner_dining': Icons.dinner_dining,
    'breakfast_dining': Icons.breakfast_dining,
    'coffee': Icons.coffee,
    'restaurant_menu': Icons.restaurant_menu,
    'cake': Icons.cake,
    'local_dining': Icons.local_dining,
    'kitchen': Icons.kitchen,

    // Transporte
    'directions_car': Icons.directions_car,
    'directions_bus': Icons.directions_bus,
    'directions_subway': Icons.directions_subway,
    'local_taxi': Icons.local_taxi,
    'directions_bike': Icons.directions_bike,
    'motorcycle': Icons.motorcycle,
    'local_gas_station': Icons.local_gas_station,
    'local_parking': Icons.local_parking,
    'flight': Icons.flight,
    'train': Icons.train,
    'directions_boat': Icons.directions_boat,
    'electric_car': Icons.electric_car,

    // Compras
    'shopping_cart': Icons.shopping_cart,
    'shopping_bag': Icons.shopping_bag,
    'local_grocery_store': Icons.local_grocery_store,
    'store': Icons.store,
    'storefront': Icons.storefront,
    'local_mall': Icons.local_mall,
    'local_offer': Icons.local_offer,
    'card_giftcard': Icons.card_giftcard,

    // Casa y hogar
    'home': Icons.home,
    'house': Icons.house,
    'weekend': Icons.weekend,
    'chair': Icons.chair,
    'bed': Icons.bed,
    'bathtub': Icons.bathtub,
    'lightbulb': Icons.lightbulb,
    'water_drop': Icons.water_drop,
    'local_laundry_service': Icons.local_laundry_service,
    'cleaning_services': Icons.cleaning_services,
    'roofing': Icons.roofing,

    // Salud y fitness
    'local_hospital': Icons.local_hospital,
    'medical_services': Icons.medical_services,
    'local_pharmacy': Icons.local_pharmacy,
    'fitness_center': Icons.fitness_center,
    'sports': Icons.sports,
    'favorite': Icons.favorite,
    'healing': Icons.healing,
    'monitor_heart': Icons.monitor_heart,
    'vaccines': Icons.vaccines,
    'medication': Icons.medication,

    // Entretenimiento
    'movie': Icons.movie,
    'theaters': Icons.theaters,
    'music_note': Icons.music_note,
    'sports_esports': Icons.sports_esports,
    'sports_soccer': Icons.sports_soccer,
    'sports_basketball': Icons.sports_basketball,
    'sports_tennis': Icons.sports_tennis,
    'casino': Icons.casino,
    'videogame_asset': Icons.videogame_asset,
    'attractions': Icons.attractions,
    'stadium': Icons.stadium,
    'celebration': Icons.celebration,

    // Educación
    'school': Icons.school,
    'menu_book': Icons.menu_book,
    'library_books': Icons.library_books,
    'auto_stories': Icons.auto_stories,
    'calculate': Icons.calculate,
    'science': Icons.science,
    'psychology': Icons.psychology,

    // Trabajo y negocios
    'work': Icons.work,
    'business': Icons.business,
    'business_center': Icons.business_center,
    'badge': Icons.badge,
    'laptop': Icons.laptop,
    'computer': Icons.computer,
    'keyboard': Icons.keyboard,
    'print': Icons.print,

    // Tecnología
    'phone': Icons.phone,
    'smartphone': Icons.smartphone,
    'tablet': Icons.tablet,
    'wifi': Icons.wifi,
    'router': Icons.router,
    'devices': Icons.devices,
    'headphones': Icons.headphones,
    'watch': Icons.watch,
    'tv': Icons.tv,

    // Ropa y moda
    'checkroom': Icons.checkroom,
    'dry_cleaning': Icons.dry_cleaning,

    // Mascotas
    'pets': Icons.pets,

    // Viajes y turismo
    'luggage': Icons.luggage,
    'hotel': Icons.hotel,
    'beach_access': Icons.beach_access,
    'landscape': Icons.landscape,
    'hiking': Icons.hiking,
    'camera': Icons.camera,
    'photo_camera': Icons.photo_camera,

    // Servicios
    'build': Icons.build,
    'handyman': Icons.handyman,
    'plumbing': Icons.plumbing,
    'electrical_services': Icons.electrical_services,
    'local_car_wash': Icons.local_car_wash,
    'local_shipping': Icons.local_shipping,
    'design_services': Icons.design_services,

    // Comunicación
    'email': Icons.email,
    'call': Icons.call,
    'message': Icons.message,
    'chat': Icons.chat,
    'forum': Icons.forum,

    // Familia y social
    'family_restroom': Icons.family_restroom,
    'people': Icons.people,
    'person': Icons.person,
    'child_care': Icons.child_care,
    'child_friendly': Icons.child_friendly,

    // Regalos y donaciones
    'redeem': Icons.redeem,
    'volunteer_activism': Icons.volunteer_activism,

    // Seguros
    'security': Icons.security,
    'verified_user': Icons.verified_user,
    'shield': Icons.shield,

    // Impuestos y legal
    'gavel': Icons.gavel,
    'balance': Icons.balance,
    'policy': Icons.policy,

    // Inversiones
    'trending_up': Icons.trending_up,
    'show_chart': Icons.show_chart,
    'pie_chart': Icons.pie_chart,
    'analytics': Icons.analytics,

    // Otros
    'category': Icons.category,
    'label': Icons.label,
    'star': Icons.star,
    'favorite_border': Icons.favorite_border,
    'bookmark': Icons.bookmark,
    'flag': Icons.flag,
    'schedule': Icons.schedule,
    'today': Icons.today,
    'event': Icons.event,
    'notifications': Icons.notifications,
    'settings': Icons.settings,
    'more_horiz': Icons.more_horiz,
    'help': Icons.help,
    'info': Icons.info,
    'error': Icons.error,
    'warning': Icons.warning,
    'check_circle': Icons.check_circle,
  };

  /// Obtiene el IconData correspondiente a un nombre de icono
  /// Si el icono no existe, retorna un icono por defecto
  static IconData getIcon(String iconName) {
    return availableIcons[iconName] ?? Icons.category;
  }

  /// Verifica si un icono existe en el mapa
  static bool iconExists(String iconName) {
    return availableIcons.containsKey(iconName);
  }

  /// Obtiene la lista de nombres de todos los iconos disponibles
  static List<String> getAllIconNames() {
    return availableIcons.keys.toList()..sort();
  }

  /// Obtiene la lista de todos los IconData disponibles
  static List<IconData> getAllIcons() {
    return availableIcons.values.toList();
  }

  /// Obtiene un mapa de iconos filtrados por categoría
  static Map<String, IconData> getIconsByCategory(String category) {
    // Implementación futura si se quiere organizar iconos por categorías
    // Por ahora retorna todos los iconos
    return availableIcons;
  }

  /// Iconos por defecto para tipos de transacciones
  static const String defaultIncomeIcon = 'trending_up';
  static const String defaultExpenseIcon = 'shopping_cart';
  static const String defaultSavingsIcon = 'savings';

  /// Iconos sugeridos para categorías comunes de gastos
  static const Map<String, String> suggestedExpenseIcons = {
    'Alimentación': 'restaurant',
    'Transporte': 'directions_car',
    'Entretenimiento': 'movie',
    'Salud': 'local_hospital',
    'Hogar': 'home',
    'Educación': 'school',
    'Ropa': 'checkroom',
    'Tecnología': 'smartphone',
    'Viajes': 'flight',
    'Otros': 'category',
  };

  /// Iconos sugeridos para categorías comunes de ingresos
  static const Map<String, String> suggestedIncomeIcons = {
    'Salario': 'work',
    'Freelance': 'laptop',
    'Inversiones': 'trending_up',
    'Bonos': 'card_giftcard',
    'Otros': 'money',
  };
}
