import 'schedule.dart';

/// A ready-made reminder from `assets/templates/*.json`.
class ReminderTemplate {
  const ReminderTemplate({
    required this.id,
    required this.title,
    required this.icon,
    required this.message,
    required this.schedule,
  });

  factory ReminderTemplate.fromJson(Map<String, dynamic> json) => ReminderTemplate(
        id: json['id'] as String,
        title: json['title'] as String,
        icon: json['icon'] as String,
        message: json['message'] as String,
        schedule: Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
      );

  final String id;
  final String title;

  /// Icon name, looked up in `lib/widgets/reminder_icons.dart`.
  final String icon;

  /// Text shown in the notification under the title.
  final String message;
  final Schedule schedule;
}

/// One section of the library, e.g. "Sức khỏe".
class TemplateGroup {
  const TemplateGroup({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.templates,
  });

  factory TemplateGroup.fromJson(Map<String, dynamic> json) => TemplateGroup(
        id: json['id'] as String,
        title: json['title'] as String,
        icon: json['icon'] as String,
        color: parseColor(json['color'] as String),
        templates: [
          for (final t in json['templates'] as List)
            ReminderTemplate.fromJson(t as Map<String, dynamic>),
        ],
      );

  final String id;
  final String title;
  final String icon;

  /// ARGB colour value.
  final int color;
  final List<ReminderTemplate> templates;

  /// Parses "#RRGGBB" into an opaque ARGB value.
  static int parseColor(String text) {
    if (!RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(text)) {
      throw FormatException('Màu không hợp lệ: "$text" (cần dạng #RRGGBB)');
    }
    return 0xFF000000 | int.parse(text.substring(1), radix: 16);
  }
}

/// A reminder the user has switched on, either from a template or self-made.
class Reminder {
  const Reminder({
    required this.id,
    required this.title,
    required this.icon,
    required this.message,
    required this.color,
    required this.schedule,
    this.templateId,
    this.since,
  });

  factory Reminder.fromTemplate(
    ReminderTemplate template,
    TemplateGroup group, {
    DateTime? since,
  }) =>
      Reminder(
        since: since,
        id: template.id,
        templateId: template.id,
        title: template.title,
        icon: template.icon,
        message: template.message,
        color: group.color,
        schedule: template.schedule,
      );

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        id: json['id'] as String,
        templateId: json['templateId'] as String?,
        title: json['title'] as String,
        icon: json['icon'] as String,
        message: json['message'] as String? ?? '',
        color: json['color'] as int,
        schedule: Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
        since: DateTime.tryParse(json['since'] as String? ?? ''),
      );

  static const customColor = 0xFF5B5BD6;
  static const customIcon = 'notifications';

  final String id;

  /// Set when this reminder came from the library; null for self-made ones.
  final String? templateId;
  final String title;
  final String icon;
  final String message;
  final int color;
  final Schedule schedule;

  /// When the reminder was switched on. Times earlier that day are not
  /// counted as missed.
  final DateTime? since;

  bool get isCustom => templateId == null;

  Reminder copyWith({String? title, String? message, Schedule? schedule}) => Reminder(
        id: id,
        templateId: templateId,
        title: title ?? this.title,
        icon: icon,
        message: message ?? this.message,
        color: color,
        schedule: schedule ?? this.schedule,
        since: since,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        if (templateId != null) 'templateId': templateId,
        'title': title,
        'icon': icon,
        'message': message,
        'color': color,
        'schedule': schedule.toJson(),
        if (since != null) 'since': since!.toIso8601String(),
      };
}
