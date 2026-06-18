import 'dart:math';

import 'package:flutter/material.dart';

import '../models/conversation.dart';

/// Mock messaging data and local state. Conversations and messages are
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

  static List<Conversation> _seedConversations() {
    final now = DateTime.now();
    return [
      Conversation(
        id: 'support',
        title: 'LM+ Support',
        avatarLabel: 'LM',
        avatarColor: const Color(0xFF2C398F),
        unreadCount: 2,
        messages: [
          ChatMessage(
            id: '1',
            text: 'Hello! How can we help you today?',
            sentAt: now.subtract(const Duration(days: 1, hours: 2)),
            isFromUser: false,
          ),
          ChatMessage(
            id: '2',
            text: "Hi, I'd like to know if the Ghent office is open on Saturdays.",
            sentAt: now.subtract(const Duration(days: 1, hours: 1, minutes: 50)),
            isFromUser: true,
          ),
          ChatMessage(
            id: '3',
            text: "Let me check that for you, one moment.",
            sentAt: now.subtract(const Duration(days: 1, hours: 1, minutes: 45)),
            isFromUser: false,
          ),
          ChatMessage(
            id: '4',
            text: 'Yes, the Ghent office is open Saturdays from 9:00 to 12:30.',
            sentAt: now.subtract(const Duration(minutes: 35)),
            isFromUser: false,
          ),
          ChatMessage(
            id: '5',
            text: 'Is there anything else we can help with?',
            sentAt: now.subtract(const Duration(minutes: 34)),
            isFromUser: false,
          ),
        ],
      ),
      Conversation(
        id: 'gent',
        title: 'LM+ Gent',
        avatarLabel: 'GE',
        avatarColor: const Color(0xFF1F7A5C),
        unreadCount: 0,
        messages: [
          ChatMessage(
            id: '1',
            text: "Hi, I dropped off a parcel yesterday — has it been processed?",
            sentAt: now.subtract(const Duration(days: 3)),
            isFromUser: true,
          ),
          ChatMessage(
            id: '2',
            text: 'Yes, it was picked up this morning. You should receive a confirmation soon.',
            sentAt: now.subtract(const Duration(days: 2, hours: 22)),
            isFromUser: false,
          ),
        ],
      ),
      Conversation(
        id: 'antwerpen',
        title: 'LM+ Antwerpen',
        avatarLabel: 'AN',
        avatarColor: const Color(0xFFB05A1F),
        unreadCount: 1,
        messages: [
          ChatMessage(
            id: '1',
            text: 'Reminder: your parcel is ready for pickup at our counter.',
            sentAt: now.subtract(const Duration(hours: 5)),
            isFromUser: false,
          ),
        ],
      ),
    ];
  }
}
