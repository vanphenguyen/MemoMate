import 'package:flutter/material.dart';

import '../app.dart';
import '../app_controller.dart';
import '../models/reminder.dart';
import '../widgets/reminder_icons.dart';
import 'edit_reminder_screen.dart';

/// Shown when the phone cannot hold any more scheduled notifications.
void showSaveProblem(BuildContext context, SaveProblem problem) {
  final l10n = AppScope.textsOf(context).l10n;
  final text = switch (problem) {
    SaveProblem.tooManyNotifications => l10n.tooManyNotifications,
  };
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

/// The library: ready-made reminders to switch on, plus self-made ones.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  Future<void> _openEditor(BuildContext context, {Reminder? reminder}) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => EditReminderScreen(reminder: reminder)),
      );

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final texts = AppScope.textsOf(context);
    final l10n = texts.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final custom = controller.customReminders;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        Text(
          l10n.activeCount(controller.reminders.length),
          style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          l10n.tabReminders,
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        FilledButton.tonalIcon(
          onPressed: () => _openEditor(context),
          icon: const Icon(Icons.add),
          label: Text(l10n.createOwn),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
        ),
        if (custom.isNotEmpty)
          _Group(
            title: l10n.groupMine,
            icon: Reminder.customIcon,
            color: Reminder.customColor,
            children: [
              for (final reminder in custom)
                _Row(
                  rowKey: ValueKey('reminder-${reminder.id}'),
                  icon: reminder.icon,
                  color: reminder.color,
                  title: controller.titleOf(reminder),
                  schedule: texts.describeSchedule(reminder.schedule),
                  active: true,
                  onTap: () => _openEditor(context, reminder: reminder),
                  onChanged: (_) => controller.disable(reminder.id),
                ),
            ],
          ),
        for (final group in controller.groups)
          _Group(
            title: group.title.resolve(texts.language),
            icon: group.icon,
            color: group.color,
            children: [
              for (final template in group.templates)
                _templateRow(context, controller, group, template),
            ],
          ),
      ],
    );
  }

  Widget _templateRow(
    BuildContext context,
    AppController controller,
    TemplateGroup group,
    ReminderTemplate template,
  ) {
    final texts = controller.texts;
    final active = controller.reminderById(template.id);
    return _Row(
      rowKey: ValueKey('reminder-${template.id}'),
      icon: template.icon,
      color: group.color,
      title: active != null ? controller.titleOf(active) : template.title.resolve(texts.language),
      schedule: texts.describeSchedule(active?.schedule ?? template.schedule),
      active: active != null,
      onTap: active == null ? null : () => _openEditor(context, reminder: active),
      onChanged: (on) async {
        if (!on) return controller.disable(template.id);
        final problem = await controller.enableTemplate(template, group);
        if (problem != null && context.mounted) showSaveProblem(context, problem);
      },
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  final String title;
  final String icon;
  final int color;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 24, 4, 8),
          child: Row(
            children: [
              Icon(reminderIcon(icon), size: 18, color: Color(color)),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    indent: 68,
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.rowKey,
    required this.icon,
    required this.color,
    required this.title,
    required this.schedule,
    required this.active,
    required this.onTap,
    required this.onChanged,
  });

  final Key rowKey;
  final String icon;
  final int color;
  final String title;

  /// The schedule already put into words.
  final String schedule;
  final bool active;

  /// Opens the editor; null while the reminder is switched off.
  final VoidCallback? onTap;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return InkWell(
      onTap: onTap ?? () => onChanged(true),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          children: [
            ReminderBadge(icon: icon, color: color, faded: !active),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (active) ...[
                        Icon(Icons.edit_outlined, size: 14, color: scheme.primary),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          schedule,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Semantics(
              label: title,
              child: Switch(key: rowKey, value: active, onChanged: onChanged),
            ),
          ],
        ),
      ),
    );
  }
}
