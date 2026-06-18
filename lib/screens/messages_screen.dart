import 'package:flutter/material.dart';

import '../models/conversation.dart';
import '../services/messaging_service.dart';
import '../widgets/conversation_tile.dart';
import 'chat_screen.dart';

/// Tab listing mock conversations between the user and LM+ (support or a
/// branch office). Backed by [MessagingService]'s in-memory mock data.
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Conversation>>(
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
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatScreen(conversationId: conversation.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
