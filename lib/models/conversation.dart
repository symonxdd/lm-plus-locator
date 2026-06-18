import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// The topic of a [Conversation]. A member only has one LM+ office, so this
/// identifies the subject of the thread rather than which office it's with.
enum ConversationTopic { dentalReimbursement, addressChange, membershipCard }

extension ConversationTopicLabel on ConversationTopic {
  String title(AppLocalizations l10n) => switch (this) {
    ConversationTopic.dentalReimbursement => l10n.messagesDentalReimbursementTitle,
    ConversationTopic.addressChange => l10n.messagesAddressChangeTitle,
    ConversationTopic.membershipCard => l10n.messagesMembershipCardTitle,
  };
}

/// Seeded/canned message bodies, resolved through [AppLocalizations] so mock
/// content follows the app's selected language like everything else does.
enum SeedMessage {
  dentalReimbursementUserQuestion,
  dentalReimbursementOfficeAck,
  dentalReimbursementOfficeApproved,
  dentalReimbursementOfficeFollowup,
  addressChangeUserQuestion,
  addressChangeOfficeReply,
  membershipCardOfficeReminder,
  cannedReply1,
  cannedReply2,
  cannedReply3,
}

extension SeedMessageText on SeedMessage {
  String text(AppLocalizations l10n) => switch (this) {
    SeedMessage.dentalReimbursementUserQuestion =>
      l10n.messagesDentalReimbursementUserQuestion,
    SeedMessage.dentalReimbursementOfficeAck => l10n.messagesDentalReimbursementOfficeAck,
    SeedMessage.dentalReimbursementOfficeApproved =>
      l10n.messagesDentalReimbursementOfficeApproved,
    SeedMessage.dentalReimbursementOfficeFollowup =>
      l10n.messagesDentalReimbursementOfficeFollowup,
    SeedMessage.addressChangeUserQuestion => l10n.messagesAddressChangeUserQuestion,
    SeedMessage.addressChangeOfficeReply => l10n.messagesAddressChangeOfficeReply,
    SeedMessage.membershipCardOfficeReminder => l10n.messagesMembershipCardOfficeReminder,
    SeedMessage.cannedReply1 => l10n.messagesCannedReply1,
    SeedMessage.cannedReply2 => l10n.messagesCannedReply2,
    SeedMessage.cannedReply3 => l10n.messagesCannedReply3,
  };
}

/// A single message within a [Conversation]. All messaging data in this app
/// is mock/local-only — there is no real send/receive backend yet.
///
/// Exactly one of [literalText] or [seedMessage] is set: messages typed by
/// the user at runtime carry their literal text as-is, while seeded/canned
/// messages carry a [SeedMessage] key so their text follows the app's
/// selected language.
class ChatMessage {
  final String id;
  final String? literalText;
  final SeedMessage? seedMessage;
  final DateTime sentAt;
  final bool isFromUser;

  const ChatMessage.typed({
    required this.id,
    required String text,
    required this.sentAt,
    required this.isFromUser,
  }) : literalText = text,
       seedMessage = null;

  const ChatMessage.seeded({
    required this.id,
    required this.seedMessage,
    required this.sentAt,
    required this.isFromUser,
  }) : literalText = null;

  String text(AppLocalizations l10n) => literalText ?? seedMessage!.text(l10n);
}

/// A mock conversation thread with the user's LM+ office about a specific
/// [topic] (e.g. a reimbursement or an address change) — a member only ever
/// has one office, so the topic identifies the thread, not the office.
/// [messages] is mutable so [MessagingService] can append to it locally when
/// the user "sends" a message.
class Conversation {
  final String id;
  final ConversationTopic topic;
  final String avatarLabel;
  final Color avatarColor;
  final List<ChatMessage> messages;
  int unreadCount;

  Conversation({
    required this.id,
    required this.topic,
    required this.avatarLabel,
    required this.avatarColor,
    required this.messages,
    this.unreadCount = 0,
  });

  ChatMessage? get lastMessage => messages.isEmpty ? null : messages.last;
}
