import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/reminder.dart';
import '../providers/reminder_provider.dart';
import '../services/reminder_service.dart';
import '../widgets/achievement_content.dart';

/// Smart-reminders settings (Sprint 2.3): per-category toggle, fire time,
/// weekday selection, custom medication reminders.
class ReminderSettingsScreen extends ConsumerWidget {
  const ReminderSettingsScreen({super.key});

  static const _weekdayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  String _titleFor(AppLocalizations l10n, Reminder r) {
    return switch (r.type) {
      ReminderType.bmiCheck => l10n.reminderBmiTitle,
      ReminderType.hydration => l10n.reminderHydrationTitle,
      ReminderType.activity => l10n.reminderActivityTitle,
      ReminderType.healthTip => l10n.reminderHealthTipTitle,
      ReminderType.medication => r.label ?? l10n.reminderMedicationTitle,
      ReminderType.dailyChallenge => l10n.reminderChallengeTitle,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncReminders = ref.watch(reminderProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reminderSettingsTitle),
        elevation: 0,
      ),
      body: asyncReminders.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (reminders) {
          final fixed = reminders
              .where((r) => r.type != ReminderType.medication)
              .toList();
          final meds = reminders
              .where((r) => r.type == ReminderType.medication)
              .toList();
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final r in [...fixed, ...meds]) ...[
                  _ReminderCard(
                    reminder: r,
                    title: _titleFor(l10n, r),
                    weekdayLetters: _weekdayLetters,
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addCustomMedication),
                    onPressed: () => _showAddMedicationDialog(context, ref),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showAddMedicationDialog(
      BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController();
    TimeOfDay time = TimeOfDay.now();
    int days = Reminder.everyDay;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.addCustomMedication),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.remindersLabel,
                    hintText: l10n.medicationNameHint,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.access_time),
                  title: Text(l10n.remindersTime),
                  trailing: Text(
                    _formatTime(time.hour, time.minute),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: DynamicColors.textPrimary(context),
                    ),
                  ),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: ctx,
                      initialTime: time,
                    );
                    if (picked != null) {
                      setDialogState(() => time = picked);
                    }
                  },
                ),
                Text(l10n.remindersDays),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: List.generate(7, (i) {
                    final active = (days & (1 << i)) != 0;
                    return ChoiceChip(
                      label: Text(_weekdayLetters[i]),
                      selected: active,
                      onSelected: (sel) => setDialogState(() {
                        days = sel ? (days | (1 << i)) : (days & ~(1 << i));
                      }),
                    );
                  }),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
        ),
      ),
    );

    if (saved == true && nameController.text.trim().isNotEmpty) {
      await ref.read(reminderProvider.notifier).addMedication(
            label: nameController.text.trim(),
            hour: time.hour,
            minute: time.minute,
            days: days,
          );
    }
    nameController.dispose();
  }
}

class _ReminderCard extends ConsumerWidget {
  const _ReminderCard({
    required this.reminder,
    required this.title,
    required this.weekdayLetters,
  });

  final Reminder reminder;
  final String title;
  final List<String> weekdayLetters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final meta = ReminderService.metaFor(reminder.type);
    final smart = meta.smart;
    final dimmed = !reminder.enabled;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  achievementIcon(meta.icon),
                  color:
                      dimmed ? Colors.grey : DynamicColors.iconColor(context),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: dimmed ? Colors.grey : null,
                                  )),
                      if (smart)
                        Text(
                          l10n.reminderSmartHint,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: kSuccessColor),
                        ),
                    ],
                  ),
                ),
                Switch(
                  value: reminder.enabled,
                  onChanged: (v) => ref
                      .read(reminderProvider.notifier)
                      .updateReminder(reminder.copyWith(enabled: v)),
                ),
              ],
            ),
            if (reminder.enabled) ...[
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: const Icon(Icons.access_time, size: 20),
                title: Text(l10n.remindersTime),
                trailing: Text(
                  _formatTime(reminder.hour, reminder.minute),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay(hour: reminder.hour, minute: reminder.minute),
                  );
                  if (picked != null) {
                    await ref.read(reminderProvider.notifier).updateReminder(
                          reminder.copyWith(
                              hour: picked.hour, minute: picked.minute),
                        );
                  }
                },
              ),
              const SizedBox(height: 4),
              Text(l10n.remindersDays,
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                children: List.generate(7, (i) {
                  final active = reminder.enabledOn(i + 1);
                  return ChoiceChip(
                    label: Text(weekdayLetters[i]),
                    selected: active,
                    onSelected: (sel) async {
                      final next = sel
                          ? (reminder.days | (1 << i))
                          : (reminder.days & ~(1 << i));
                      await ref
                          .read(reminderProvider.notifier)
                          .updateReminder(reminder.copyWith(days: next));
                    },
                  );
                }),
              ),
              if (reminder.type == ReminderType.medication) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.delete_outline,
                        color: kErrorColor, size: 18),
                    label: Text(l10n.deleteReminder,
                        style: const TextStyle(color: kErrorColor)),
                    onPressed: () async {
                      if (reminder.id != null) {
                        await ref
                            .read(reminderProvider.notifier)
                            .deleteReminder(reminder.id!);
                      }
                    },
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

String _formatTime(int hour, int minute) =>
    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
