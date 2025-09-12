import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum MessageType { text, image, file }
enum ChatType { individual, group }

class ChatMessage extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String text;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
  final String? fileUrl;
  final String? fileName;
  final String? senderRole;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.text,
    this.type = MessageType.text,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
    this.fileUrl,
    this.fileName,
    this.senderRole,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      conversationId: data['conversationId'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      text: data['text'] ?? '',
      type: MessageType.values.byName(data['type'] ?? 'text'),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
      imageUrl: data['imageUrl'],
      fileUrl: data['fileUrl'],
      fileName: data['fileName'],
      senderRole: data['senderRole'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'type': type.name,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'imageUrl': imageUrl,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'senderRole': senderRole,
    };
  }

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        senderName,
        text,
        type,
        timestamp,
        isRead,
        imageUrl,
        fileUrl,
        fileName,
        senderRole,
      ];
}

class ChatConversation extends Equatable {
  final String id;
  final ChatType type;
  final String name;
  final String? avatar;
  final List<String> participantIds;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastMessageSenderId;
  final int unreadCount;
  final bool isActive;
  final DateTime createdAt;
  final List<String>? participantNames;
  final Map<String, String>? participantRoles;

  const ChatConversation({
    required this.id,
    required this.type,
    required this.name,
    this.avatar,
    required this.participantIds,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSenderId,
    this.unreadCount = 0,
    this.isActive = true,
    required this.createdAt,
    this.participantNames,
    this.participantRoles,
  });

  factory ChatConversation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatConversation(
      id: doc.id,
      type: ChatType.values.byName(data['type'] ?? 'individual'),
      name: data['name'] ?? '',
      avatar: data['avatar'],
      participantIds: List<String>.from(data['participantIds'] ?? []),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
      lastMessageSenderId: data['lastMessageSenderId'] ?? '',
      unreadCount: data['unreadCount'] ?? 0,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      participantNames: data['participantNames'] != null ? List<String>.from(data['participantNames']) : null,
      participantRoles: data['participantRoles'] != null ? Map<String, String>.from(data['participantRoles']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type.name,
      'name': name,
      'avatar': avatar,
      'participantIds': participantIds,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'lastMessageSenderId': lastMessageSenderId,
      'unreadCount': unreadCount,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'participantNames': participantNames,
      'participantRoles': participantRoles,
    };
  }

  ChatConversation copyWith({
    String? id,
    ChatType? type,
    String? name,
    String? avatar,
    List<String>? participantIds,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastMessageSenderId,
    int? unreadCount,
    bool? isActive,
    DateTime? createdAt,
    List<String>? participantNames,
    Map<String, String>? participantRoles,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      participantIds: participantIds ?? this.participantIds,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      unreadCount: unreadCount ?? this.unreadCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      participantNames: participantNames ?? this.participantNames,
      participantRoles: participantRoles ?? this.participantRoles,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        name,
        avatar,
        participantIds,
        lastMessage,
        lastMessageTime,
        lastMessageSenderId,
        unreadCount,
        isActive,
        createdAt,
        participantNames,
        participantRoles,
      ];
}