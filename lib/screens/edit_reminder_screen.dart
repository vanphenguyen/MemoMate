import 'package:flutter/material.dart';

import '../app.dart';
import '../models/reminder.dart';
import '../models/schedule.dart';
import 'library_screen.dart';

/// Creates a self-made reminder, or changes the schedule of an existing one.
class EditReminderScreen extends StatefulWidget {
  const EditReminderScreen({super.key, this.reminder});

  /// The reminder to change; null to create a new one.
  final Reminder? reminder;

  @override
  State<EditReminderScreen> createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {
  late final TextEditingController _title;
  late ScheduleType _type;
  late List<ClockTime> _times;
  late Set<int> _weekdays;
  late int _dayOfMonth;
  String? _error;

  bool get _isNew => widget.reminder == null;

  @override
  void initState() {
    super.initState();
    final reminder = widget.reminder;
    final schedule = reminder?.schedule;
    _title = TextEditingController(text: reminder?.title ?? '');
    _type = schedule?.type ?? ScheduleType.daily;
    _times = List.of(schedule?.times ?? const [ClockTime(9, 0)]);
    _weekdays = Set.of(
      schedule?.type == ScheduleType.weekly ? schedule!.weekdays : const {1, 2, 3, 4, 5},
    );
    _dayOfMonth = schedule?.type == ScheduleType.monthly ? schedule!.dayOfMonth : 1;
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Schedule get _schedule => switch (_type) {
        ScheduleType.daily => Schedule.daily(_times),
        ScheduleType.weekly => Schedule.weekly(_times, _weekdays),
        ScheduleType.monthly => Schedule.monthly(_times, _dayOfMonth),
      };

  Future<void> _addTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
      helpText: 'Chọn giờ nhắc',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked == null) return;
    final time = ClockTime(picked.hour, picked.minute);
    if (_times.contains(time)) return;
    setState(() => _times = [..._times, time]..sort());
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    final schedule = _schedule;
    final problem = title.isEmpty ? 'Hãy đặt tên cho lời nhắc.' : schedule.validate();
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }
    final controller = AppScope.of(context);
    final existing = widget.reminder;
    final reminder = existing != null
        ? existing.copyWith(
            title: title,
            // A self-made reminder repeats its name as the notification text.
            message: existing.isCustom ? 'Đến giờ: $title' : null,
            schedule: schedule,
          )
        : Reminder(
            id: 'custom-${controller.now.microsecondsSinceEpoch}',
            title: title,
            icon: Reminder.customIcon,
            message: 'Đến giờ: $title',
            color: Reminder.customColor,
            schedule: schedule,
            since: controller.now,
          );
    final saveProblem = await controller.saveReminder(reminder);
    if (!mounted) return;
    if (saveProblem != null) return showSaveProblem(context, saveProblem);
    Navigator.of(context).pop();
  }

  Future<void> _remove() async {
    final reminder = widget.reminder!;
    await AppScope.of(context).disable(reminder.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isTemplate = widget.reminder != null && !widget.reminder!.isCustom;

    return Scaffold(
      appBar: AppBar(title: Text(_isNew ? 'Lời nhắc mới' : 'Sửa lời nhắc')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            TextField(
              key: const ValueKey('title-field'),
              controller: _title,
              autofocus: _isNew,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 40,
              decoration: const InputDecoration(
                labelText: 'Nhắc việc gì?',
                hintText: 'Ví dụ: Cho mèo ăn',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() => _error = null),
            ),
            const _Label('Lặp lại'),
            SegmentedButton<ScheduleType>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: ScheduleType.daily, label: Text('Mỗi ngày')),
                ButtonSegment(value: ScheduleType.weekly, label: Text('Theo tuần')),
                ButtonSegment(value: ScheduleType.monthly, label: Text('Theo tháng')),
              ],
              selected: {_type},
              onSelectionChanged: (value) => setState(() {
                _type = value.first;
                _error = null;
              }),
            ),
            if (_type == ScheduleType.weekly) ...[
              const _Label('Vào các ngày'),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (var day = 1; day <= 7; day++)
                    FilterChip(
                      label: Text(Schedule.weekdayName(day)),
                      showCheckmark: false,
                      selected: _weekdays.contains(day),
                      onSelected: (on) => setState(() {
                        on ? _weekdays.add(day) : _weekdays.remove(day);
                        _error = null;
                      }),
                    ),
                ],
              ),
            ],
            if (_type == ScheduleType.monthly) ...[
              const _Label('Vào ngày'),
              DropdownButtonFormField<int>(
                initialValue: _dayOfMonth,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  helperText: 'Chỉ chọn được đến ngày 28 vì tháng nào cũng có.',
                ),
                items: [
                  for (var day = 1; day <= Schedule.maxDayOfMonth; day++)
                    DropdownMenuItem(value: day, child: Text('Ngày $day hằng tháng')),
                ],
                onChanged: (day) => setState(() => _dayOfMonth = day ?? _dayOfMonth),
              ),
            ],
            const _Label('Giờ nhắc'),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final time in _times)
                  InputChip(
                    label: Text(time.label),
                    deleteButtonTooltipMessage: 'Bỏ giờ ${time.label}',
                    onDeleted: () => setState(() {
                      _times = [..._times]..remove(time);
                      _error = null;
                    }),
                  ),
                ActionChip(
                  key: const ValueKey('add-time'),
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('Thêm giờ'),
                  onPressed: _addTime,
                ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(_error!, style: TextStyle(color: scheme.error)),
            ],
            const SizedBox(height: 28),
            FilledButton(
              key: const ValueKey('save'),
              onPressed: _save,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              child: const Text('Lưu'),
            ),
            if (!_isNew) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: _remove,
                style: TextButton.styleFrom(
                  foregroundColor: scheme.error,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: Text(isTemplate ? 'Tắt lời nhắc này' : 'Xóa lời nhắc này'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
