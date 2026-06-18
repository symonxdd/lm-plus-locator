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

  static const _cannedReplies = [
    "Thanks for your message! We'll get back to you shortly.",
    "Got it — someone from our team will follow up soon.",
    "Thanks for reaching out. We'll review this and reply as soon as we can.",
  ];

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
      ChatMessage(
        id: _newId(),
        text: text.trim(),
        sentAt: DateTime.now(),
        isFromUser: true,
      ),
    );
    _notify();

    Future.delayed(const Duration(milliseconds: 1200), () {
      conversation.messages.add(
        ChatMessage(
          id: _newId(),
          text: _cannedReplies[_random.nextInt(_cannedReplies.length)],
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
        title: 'Terugbetaling tandzorg',
        avatarLabel: _officeLabel,
        avatarColor: _officeColor,
        unreadCount: 2,
        messages: [
          ChatMessage(
            id: '1',
            text: "Hi, I submitted a dental care claim last week — any update on the reimbursement?",
            sentAt: now.subtract(const Duration(days: 1, hours: 2)),
            isFromUser: true,
          ),
          ChatMessage(
            id: '2',
            text: "Let me check that for you, one moment.",
            sentAt: now.subtract(const Duration(days: 1, hours: 1, minutes: 50)),
            isFromUser: false,
          ),
          ChatMessage(
            id: '3',
            text: "Your claim has been approved. The reimbursement will be transferred within 5 business days.",
            sentAt: now.subtract(const Duration(minutes: 35)),
            isFromUser: false,
          ),
          ChatMessage(
            id: '4',
            text: 'Is there anything else we can help with?',
            sentAt: now.subtract(const Duration(minutes: 34)),
            isFromUser: false,
          ),
        ],
      ),
      Conversation(
        id: 'address-change',
        title: 'Adreswijziging',
        avatarLabel: _officeLabel,
        avatarColor: _officeColor,
        unreadCount: 0,
        messages: [
          ChatMessage(
            id: '1',
            text: "Hi, I recently moved — do I need to update my address with you myself?",
            sentAt: now.subtract(const Duration(days: 3)),
            isFromUser: true,
          ),
          ChatMessage(
            id: '2',
            text: 'No need — we received the update automatically from the population registry. Your file is up to date.',
            sentAt: now.subtract(const Duration(days: 2, hours: 22)),
            isFromUser: false,
          ),
        ],
      ),
      Conversation(
        id: 'membership-card',
        title: 'Lidkaart vervangen',
        avatarLabel: _officeLabel,
        avatarColor: _officeColor,
        unreadCount: 1,
        messages: [
          ChatMessage(
            id: '1',
            text: 'Reminder: your replacement membership card is ready for pickup at our counter.',
            sentAt: now.subtract(const Duration(hours: 5)),
            isFromUser: false,
          ),
        ],
      ),
    ];
  }
}
