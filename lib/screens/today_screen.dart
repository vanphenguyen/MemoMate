import 'package:flutter/material.dart';

import '../app.dart';
import '../logic/today.dart';
import '../models/schedule.dart';
import '../widgets/progress_ring.dart';
import '../widgets/reminder_icons.dart';

/// Today's reminders with one-tap ticking.
class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key, required this.onOpenLibrary});

  final VoidCallback onOpenLibrary;

  static String dateLabel(DateTime day) {
    final weekday = day.weekday == DateTime.sunday ? 'Chủ nhật' : 'Thứ ${day.weekday + 1}';
    return '$weekday, ${day.day} tháng ${day.month}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final now = controller.now;
    final items = controller.today();
    final pending = [for (final i in items) if (!i.done) i];
    final done = [for (final i in items) if (i.done) i];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        Text(
          dateLabel(now),
          style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          'Hôm nay',
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        if (!controller.notifier.supported) ...[
          const _Notice(
            icon: Icons.info_outline,
            text: 'Đây là bản xem thử trên web nên không gửi thông báo. '
                'Thông báo chỉ hoạt động trong app trên điện thoại.',
          ),
          const SizedBox(height: 12),
        ] else if (!controller.notificationsAllowed) ...[
          const _Notice(
            icon: Icons.notifications_off_outlined,
            text: 'Thông báo đang bị tắt. Hãy bật thông báo cho Nhớ Nhé '
                'trong phần Cài đặt của điện thoại để nhận lời nhắc.',
          ),
          const SizedBox(height: 12),
        ],
        if (controller.reminders.isEmpty)
          _Empty(
            icon: Icons.notifications_active_outlined,
            title: 'Chưa có lời nhắc nào',
            body: 'Chọn vài lời nhắc có sẵn, bật lên là xong.',
            actionLabel: 'Xem lời nhắc có sẵn',
            onAction: onOpenLibrary,
          )
        else if (items.isEmpty)
          const _Empty(
            icon: Icons.wb_sunny_outlined,
            title: 'Hôm nay không có việc gì',
            body: 'Các lời nhắc của bạn rơi vào những ngày khác.',
          )
        else ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  ProgressRing(done: done.length, total: items.length),
                  const SizedBox(width: 20),
                  Expanded(child: _Summary(pending: pending, now: now)),
                ],
              ),
            ),
          ),
          if (pending.isNotEmpty) ...[
            const _SectionTitle('Cần làm'),
            for (final item in pending) _ItemTile(item: item, now: now),
          ],
          if (done.isNotEmpty) ...[
            const _SectionTitle('Đã xong'),
            for (final item in done) _ItemTile(item: item, now: now),
          ],
        ],
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.pending, required this.now});

  final List<TodayItem> pending;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final overdue = pending.where((i) => i.isOverdue(now)).length;
    final next = pending.where((i) => !i.isOverdue(now)).firstOrNull;

    final String title;
    final String body;
    if (pending.isEmpty) {
      title = 'Xong hết rồi!';
      body = 'Bạn không quên việc nào hôm nay.';
    } else if (overdue > 0) {
      title = '$overdue việc đã qua giờ';
      body = 'Chạm vào ô tròn để đánh dấu đã làm.';
    } else {
      title = 'Tiếp theo lúc ${next!.time.label}';
      body = next.reminder.title;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(body, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 8),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({required this.item, required this.now});

  final TodayItem item;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final overdue = item.isOverdue(now);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('today-${item.key}'),
          onTap: () => AppScope.of(context).toggleDone(item),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
            child: Row(
              children: [
                ReminderBadge(
                  icon: item.reminder.icon,
                  color: item.reminder.color,
                  faded: item.done,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.reminder.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: item.done ? scheme.onSurfaceVariant : null,
                          decoration: item.done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        overdue ? '${item.time.label} · đã qua giờ' : item.time.label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: overdue ? scheme.error : scheme.onSurfaceVariant,
                          fontWeight: overdue ? FontWeight.w600 : null,
                        ),
                      ),
                    ],
                  ),
                ),
                Semantics(
                  checked: item.done,
                  label: _tickLabel(item.reminder.title, item.time),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(
                      item.done ? Icons.check_circle : Icons.radio_button_unchecked,
                      size: 30,
                      color: item.done ? const Color(0xFF2E9E6B) : scheme.outline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _tickLabel(String title, ClockTime time) => '$title lúc ${time.label}';
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: scheme.onSecondaryContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: scheme.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 56),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
            child: Icon(icon, size: 44, color: scheme.onPrimaryContainer),
          ),
          const SizedBox(height: 20),
          Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            body,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 20),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
