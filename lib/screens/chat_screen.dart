import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/conversation.dart';
import '../services/messaging_service.dart';
import '../theme/app_colors.dart';
import '../widgets/message_bubble.dart';

/// Detail screen for a single mock conversation. Sending a message appends
/// it locally and triggers a canned auto-reply after a short delay — there's
/// no real backend behind this yet.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Deferred: calling this synchronously here would mutate the
    // ValueNotifier mid-build (the very first build of this widget),
    // which throws "setState() called during build".
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MessagingService.instance.markAsRead(widget.conversationId);
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void _send() {
    final text = _inputController.text;
    if (text.trim().isEmpty) return;
    MessagingService.instance.sendMessage(widget.conversationId, text);
    _inputController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ValueListenableBuilder<List<Conversation>>(
      valueListenable: MessagingService.instance.conversations,
      builder: (context, conversations, _) {
        final conversation = conversations.firstWhere((c) => c.id == widget.conversationId);
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: conversation.avatarColor,
                  child: Text(
                    conversation.avatarLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    conversation.topic.title(l10n),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: conversation.messages.length,
                  itemBuilder: (context, index) =>
                      MessageBubble(message: conversation.messages[index]),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _send(),
                          decoration: InputDecoration(
                            hintText: l10n.chatInputHint,
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainerHighest,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.send, color: ctaColors(context).background),
                        tooltip: l10n.chatSendTooltip,
                        onPressed: _send,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
