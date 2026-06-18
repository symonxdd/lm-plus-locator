import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/conversation.dart';
import '../services/messaging_service.dart';
import '../widgets/conversation_tile.dart';
import 'chat_screen.dart';

/// Tab listing mock conversation threads with the user's LM+ office, one
/// per topic. Backed by [MessagingService]'s in-memory mock data.
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder<List<Conversation>>(
            valueListenable: MessagingService.instance.conversations,
            builder: (context, conversations, _) {
              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: conversations.length,
                separatorBuilder: (_, _) => const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  return ConversationTile(
                    conversation: conversation,
                    onTap: () => Navigator.of(context).push(_chatRoute(conversation.id)),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Text(
            l10n.messagesExperimentalNotice,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
          ),
        ),
      ],
    );
  }

  // A plain slide, no fade — the default Material page transition fades the
  // incoming screen in, which (combined with everything else in the app
  // being instant tab switches or sheets) reads as the chat content loading
  // late rather than as a transition.
  Route<void> _chatRoute(String conversationId) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) =>
          ChatScreen(conversationId: conversationId),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offset = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        return SlideTransition(position: offset, child: child);
      },
    );
  }
}
