import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/office.dart';

/// Bottom sheet showing the full weekly opening hours for an [Office].
class OpeningHoursSheet extends StatelessWidget {
  const OpeningHoursSheet({super.key, required this.office});

  final Office office;

  // Display order: Mon → Sun (standard European week layout).
  static const _displayOrder = [1, 2, 3, 4, 5, 6, 0];

  // A known Monday used as an anchor for producing localised weekday names
  // via DateFormat without depending on the current date.
  static final _anchorMonday = DateTime(2025, 1, 6);

  String _weekdayName(int dayKey, String locale) {
    // dayKey: 0=Sun, 1=Mon … 6=Sat  →  offset from Monday anchor
    final offset = dayKey == 0 ? 6 : dayKey - 1;
    return DateFormat('EEEE', locale).format(
      _anchorMonday.add(Duration(days: offset)),
    );
  }

  String _formatTime(int hhmm) {
    final h = hhmm ~/ 100;
    final m = hhmm % 100;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  String _formatSlot(List<int> slot) => '${_formatTime(slot[0])} – ${_formatTime(slot[1])}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final hours = office.openingHours!;
    // DateTime.weekday: 1=Mon…7=Sun; %7 gives 0=Sun, 1=Mon…6=Sat
    final todayKey = DateTime.now().weekday % 7;
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.openingHoursTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              office.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 16),
            for (final dayKey in _displayOrder)
              _DayRow(
                dayName: _weekdayName(dayKey, locale),
                slots: hours.slotsByWeekday[dayKey] ?? [],
                isToday: dayKey == todayKey,
                todayLabel: l10n.openingHoursTodayLabel,
                closedLabel: l10n.openingHoursClosed,
                formatSlot: _formatSlot,
              ),
          ],
        ),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.dayName,
    required this.slots,
    required this.isToday,
    required this.todayLabel,
    required this.closedLabel,
    required this.formatSlot,
  });

  final String dayName;
  final List<List<int>> slots;
  final bool isToday;
  final String todayLabel;
  final String closedLabel;
  final String Function(List<int>) formatSlot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final nameStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
      color: isToday ? theme.colorScheme.primary : null,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Wrap(
              spacing: 6,
              children: [
                Text(dayName, style: nameStyle),
                if (isToday)
                  Text(
                    todayLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: slots.isEmpty
                ? Text(
                    closedLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final slot in slots) Text(formatSlot(slot)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
