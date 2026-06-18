import 'package:flutter/material.dart';

/// A single message within a [Conversation]. All messaging data in this app
/// is mock/local-only — there is no real send/receive backend yet.
class ChatMessage {
  final String id;
  final String text;
  final DateTime sentAt;
  final bool isFromUser;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.isFromUser,
  });
}

/// A mock conversation thread with the user's LM+ office about a specific
/// topic (e.g. a reimbursement or an address change) — a member only ever
/// has one office, so [title] is the topic, not the office's name.
/// [messages] is mutable so [MessagingService] can append to it locally when
/// the user "sends" a message.
class Conversation {
  final String id;
  final String title;
  final String avatarLabel;
  final Color avatarColor;
  final List<ChatMessage> messages;
  int unreadCount;

  Conversation({
    required this.id,
    required this.title,
    required this.avatarLabel,
    required this.avatarColor,
    required this.messages,
    this.unreadCount = 0,
  });

  ChatMessage? get lastMessage => messages.isEmpty ? null : messages.last;
}
