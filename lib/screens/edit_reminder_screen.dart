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
    _title = TextEditingController();
    _type = schedule?.type ?? ScheduleType.daily;
    _times = List.of(schedule?.times ?? const [ClockTime(9, 0)]);
    _weekdays = Set.of(
      schedule?.type == ScheduleType.weekly ? schedule!.weekdays : const {1, 2, 3, 4, 5},
    );
    _dayOfMonth = schedule?.type == ScheduleType.monthly ? schedule!.dayOfMonth : 1;
  }

  bool _filledTitle = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The ready-made name depends on the language, so it is read here.
    if (!_filledTitle && widget.reminder != null) {
      _title.text = AppScope.of(context).titleOf(widget.reminder!);
      _filledTitle = true;
    }
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
      helpText: AppScope.textsOf(context).l10n.pickTimeHelp,
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
    final controller = AppScope.of(context);
    final texts = controller.texts;
    final title = _title.text.trim();
    final schedule = _schedule;
    final scheduleProblem = schedule.validate();
    final problem = title.isEmpty
        ? texts.l10n.errorNoTitle
        : scheduleProblem == null
            ? null
            : texts.scheduleProblem(scheduleProblem);
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }
    final existing = widget.reminder;
    // A library reminder whose name was left alone keeps following the
    // phone's language instead of freezing in today's language.
    final keepsReadyMadeName = existing != null &&
        existing.title == null &&
        title == controller.titleOf(existing);
    final reminder = existing != null
        ? existing.edited(title: keepsReadyMadeName ? null : title, schedule: schedule)
        : Reminder(
            id: 'custom-${controller.now.microsecondsSinceEpoch}',
            title: title,
            icon: Reminder.customIcon,
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
    final texts = AppScope.textsOf(context);
    final l10n = texts.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isTemplate = widget.reminder != null && !widget.reminder!.isCustom;

    return Scaffold(
      appBar: AppBar(title: Text(_isNew ? l10n.editNewTitle : l10n.editEditTitle)),
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
              decoration: InputDecoration(
                labelText: l10n.fieldTitleLabel,
                hintText: l10n.fieldTitleHint,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() => _error = null),
            ),
            _Label(l10n.labelRepeat),
            SegmentedButton<ScheduleType>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: ScheduleType.daily, label: _SegmentLabel(l10n.repeatDaily)),
                ButtonSegment(value: ScheduleType.weekly, label: _SegmentLabel(l10n.repeatWeekly)),
                ButtonSegment(value: ScheduleType.monthly, label: _SegmentLabel(l10n.repeatMonthly)),
              ],
              selected: {_type},
              onSelectionChanged: (value) => setState(() {
                _type = value.first;
                _error = null;
              }),
            ),
            if (_type == ScheduleType.weekly) ...[
              _Label(l10n.labelOnDays),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (var day = 1; day <= 7; day++)
                    FilterChip(
                      label: Text(texts.weekdayName(day)),
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
              _Label(l10n.labelOnDay),
              DropdownButtonFormField<int>(
                // Long translations get the full width instead of overflowing.
                isExpanded: true,
                initialValue: _dayOfMonth,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  helperText: l10n.dayOfMonthHelper,
                  helperMaxLines: 2,
                ),
                items: [
                  for (var day = 1; day <= Schedule.maxDayOfMonth; day++)
                    DropdownMenuItem(value: day, child: Text(l10n.dayOfMonthOption(day))),
                ],
                onChanged: (day) => setState(() => _dayOfMonth = day ?? _dayOfMonth),
              ),
            ],
            _Label(l10n.labelTimes),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final time in _times)
                  InputChip(
                    label: Text(time.label),
                    deleteButtonTooltipMessage: l10n.removeTime(time.label),
                    onDeleted: () => setState(() {
                      _times = [..._times]..remove(time);
                      _error = null;
                    }),
                  ),
                ActionChip(
                  key: const ValueKey('add-time'),
                  avatar: const Icon(Icons.add, size: 18),
                  label: Text(l10n.addTime),
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
              child: Text(l10n.save),
            ),
            if (!_isNew) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: _remove,
                style: TextButton.styleFrom(
                  foregroundColor: scheme.error,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: Text(isTemplate ? l10n.turnOffReminder : l10n.deleteReminder),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A segment's text, shrunk a little when a translation is too long to fit.
class _SegmentLabel extends StatelessWidget {
  const _SegmentLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      FittedBox(fit: BoxFit.scaleDown, child: Text(text, softWrap: false));
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
