import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/conversation.dart';
import '../theme/app_colors.dart';

/// A single chat bubble, right-aligned in the CTA color for the user's own
/// messages and left-aligned in a neutral surface color for the other side.
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isUser = message.isFromUser;
    final cta = ctaColors(context);
    final backgroundColor = isUser ? cta.background : theme.colorScheme.surfaceContainerHighest;
    final textColor = isUser ? cta.foreground : theme.colorScheme.onSurface;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message.text(l10n), style: theme.textTheme.bodyMedium?.copyWith(color: textColor)),
            const SizedBox(height: 4),
            Text(
              DateFormat.Hm().format(message.sentAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: textColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
