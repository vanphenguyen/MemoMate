import 'package:flutter/material.dart';

/// Icons that `assets/templates/*.json` may name in an "icon" field.
/// To use a new icon in the JSON, add it here first.
const reminderIcons = <String, IconData>{
  'accessibility_new': Icons.accessibility_new,
  'alarm': Icons.alarm,
  'battery_charging_full': Icons.battery_charging_full,
  'bed': Icons.bed,
  'bedtime': Icons.bedtime,
  'bolt': Icons.bolt,
  'book': Icons.menu_book,
  'cake': Icons.cake,
  'call': Icons.call,
  'car': Icons.directions_car,
  'chat': Icons.chat,
  'cleaning': Icons.cleaning_services,
  'credit_card': Icons.credit_card,
  'delete': Icons.delete,
  'door_front': Icons.door_front_door,
  'favorite': Icons.favorite,
  'filter_alt': Icons.filter_alt,
  'fitness': Icons.fitness_center,
  'food': Icons.restaurant,
  'groups': Icons.groups,
  'home': Icons.home,
  'house': Icons.house,
  'key': Icons.key,
  'local_florist': Icons.local_florist,
  'local_laundry_service': Icons.local_laundry_service,
  'medication': Icons.medication,
  'notifications': Icons.notifications,
  'payments': Icons.payments,
  'pets': Icons.pets,
  'school': Icons.school,
  'shopping': Icons.shopping_cart,
  'spa': Icons.spa,
  'star': Icons.star,
  'visibility': Icons.visibility,
  'water': Icons.water,
  'water_drop': Icons.water_drop,
  'wifi': Icons.wifi,
  'work': Icons.work,
};

/// Icons offered when making a reminder of your own, in display order.
const customIconChoices = <String>[
  'notifications', 'alarm', 'star', 'favorite', 'medication', 'water_drop',
  'food', 'fitness', 'pets', 'local_florist', 'cleaning', 'shopping',
  'payments', 'call', 'work', 'school', 'book', 'car', 'cake', 'home',
];

IconData reminderIcon(String name) => reminderIcons[name] ?? Icons.notifications;

/// A round coloured badge holding a reminder's icon.
class ReminderBadge extends StatelessWidget {
  const ReminderBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 44,
    this.faded = false,
  });

  final String icon;
  final int color;
  final double size;
  final bool faded;

  @override
  Widget build(BuildContext context) {
    final base = Color(color);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: base.withValues(alpha: faded ? 0.08 : 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        reminderIcon(icon),
        size: size * 0.52,
        color: faded ? base.withValues(alpha: 0.45) : base,
      ),
    );
  }
}
