import 'dart:math';

import 'package:flutter/material.dart';

import '../models/conversation.dart';

/// Mock messaging data and local state. A member only ever has one LM+
/// office, so conversations here represent separate topics/threads with
/// that single office rather than chats with different branches. Data is
/// seeded in-memory and never persisted or sent anywhere — there's no real
/// backend behind this feature yet, just a UI showcase that feels alive.
///
/// Access via [MessagingService.instance].
class MessagingService {
  MessagingService._();
  static final instance = MessagingService._();

  static final _random = Random();

  static const _cannedReplies = [SeedMessage.cannedReply1, SeedMessage.cannedReply2, SeedMessage.cannedReply3];

  /// Reactive list of conversations. Listen with [ValueListenableBuilder].
  final conversations = ValueNotifier<List<Conversation>>(_seedConversations());

  Conversation? conversationById(String id) {
    for (final conversation in conversations.value) {
      if (conversation.id == id) return conversation;
    }
    return null;
  }

  /// Appends a message from the user, then simulates a canned reply after a
  /// short delay so the chat doesn't feel static.
  void sendMessage(String conversationId, String text) {
    final conversation = conversationById(conversationId);
    if (conversation == null || text.trim().isEmpty) return;

    conversation.messages.add(
      ChatMessage.typed(
        id: _newId(),
        text: text.trim(),
        sentAt: DateTime.now(),
        isFromUser: true,
      ),
    );
    _notify();

    Future.delayed(const Duration(milliseconds: 1200), () {
      conversation.messages.add(
        ChatMessage.seeded(
          id: _newId(),
          seedMessage: _cannedReplies[_random.nextInt(_cannedReplies.length)],
          sentAt: DateTime.now(),
          isFromUser: false,
        ),
      );
      _notify();
    });
  }

  /// Clears the unread badge for a conversation, e.g. when its chat is opened.
  void markAsRead(String conversationId) {
    final conversation = conversationById(conversationId);
    if (conversation == null || conversation.unreadCount == 0) return;
    conversation.unreadCount = 0;
    _notify();
  }

  // Reassigns the notifier to a new list reference so ValueListenableBuilder
  // rebuilds even though the mutated Conversation objects are unchanged.
  void _notify() => conversations.value = List.of(conversations.value);

  static String _newId() => DateTime.now().microsecondsSinceEpoch.toString();

  // A member is enrolled with exactly one LM+ office (their local
  // mutualiteit branch), so every thread below shares that same identity —
  // what differs between conversations is the topic, not who it's with.
  static const _officeLabel = 'GE';
  static const _officeColor = Color(0xFF2C398F);

  static List<Conversation> _seedConversations() {
    final now = DateTime.now();
    return [
      Conversation(
        id: 'dental-reimbursement',
        topic: ConversationTopic.dentalReimbursement,
        avatarLabel: _officeLabel,
        avatarColor: _officeColor,
        unreadCount: 2,
        messages: [
          ChatMessage.seeded(
            id: '1',
            seedMessage: SeedMessage.dentalReimbursementUserQuestion,
            sentAt: now.subtract(const Duration(days: 1, hours: 2)),
            isFromUser: true,
          ),
          ChatMessage.seeded(
            id: '2',
            seedMessage: SeedMessage.dentalReimbursementOfficeAck,
            sentAt: now.subtract(const Duration(days: 1, hours: 1, minutes: 50)),
            isFromUser: false,
          ),
          ChatMessage.seeded(
            id: '3',
            seedMessage: SeedMessage.dentalReimbursementOfficeApproved,
            sentAt: now.subtract(const Duration(minutes: 35)),
            isFromUser: false,
          ),
          ChatMessage.seeded(
            id: '4',
            seedMessage: SeedMessage.dentalReimbursementOfficeFollowup,
            sentAt: now.subtract(const Duration(minutes: 34)),
            isFromUser: false,
          ),
        ],
      ),
      Conversation(
        id: 'address-change',
        topic: ConversationTopic.addressChange,
        avatarLabel: _officeLabel,
        avatarColor: _officeColor,
        unreadCount: 0,
        messages: [
          ChatMessage.seeded(
            id: '1',
            seedMessage: SeedMessage.addressChangeUserQuestion,
            sentAt: now.subtract(const Duration(days: 3)),
            isFromUser: true,
          ),
          ChatMessage.seeded(
            id: '2',
            seedMessage: SeedMessage.addressChangeOfficeReply,
            sentAt: now.subtract(const Duration(days: 2, hours: 22)),
            isFromUser: false,
          ),
        ],
      ),
      Conversation(
        id: 'membership-card',
        topic: ConversationTopic.membershipCard,
        avatarLabel: _officeLabel,
        avatarColor: _officeColor,
        unreadCount: 1,
        messages: [
          ChatMessage.seeded(
            id: '1',
            seedMessage: SeedMessage.membershipCardOfficeReminder,
            sentAt: now.subtract(const Duration(hours: 5)),
            isFromUser: false,
          ),
        ],
      ),
    ];
  }
}
