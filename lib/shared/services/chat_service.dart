import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_models.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';

class ChatService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get currentUserId => _auth.currentUser?.uid;

  static Stream<List<ChatConversation>> getConversations() {
    final userId = currentUserId;
    if (userId == null) return Stream.value([]);

    return FirebaseService.getConversations(userId);
  }

  static Stream<List<ChatMessage>> getMessages(String conversationId) {
    return FirebaseService.getMessages(conversationId);
  }

  static Future<String> sendMessage({
    required String conversationId,
    required String text,
    MessageType type = MessageType.text,
    String? imageUrl,
    String? fileUrl,
    String? fileName,
  }) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final userProfile = await FirebaseService.getUserProfile(userId);
    if (userProfile == null) throw Exception('User profile not found');

    return await FirebaseService.sendMessage(
      conversationId: conversationId,
      senderId: userId,
      senderName: userProfile.name,
      text: text,
      type: type,
      imageUrl: imageUrl,
      fileUrl: fileUrl,
      fileName: fileName,
      senderRole: userProfile.role.name,
    );
  }

  static Future<String> createOrGetConversation({
    required String otherUserId,
    required String otherUserName,
  }) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    // Check if conversation already exists
    final existingConversations = await _firestore
        .collection('conversations')
        .where('type', isEqualTo: 'individual')
        .where('participantIds', arrayContains: userId)
        .get();

    for (final doc in existingConversations.docs) {
      final conversation = ChatConversation.fromFirestore(doc);
      if (conversation.participantIds.contains(otherUserId)) {
        return doc.id;
      }
    }

    // Create new conversation
    return await FirebaseService.createConversation(
      type: ChatType.individual,
      name: otherUserName,
      participantIds: [userId, otherUserId],
    );
  }

  static Future<String> createGroupConversation({
    required String name,
    required List<String> participantIds,
  }) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final allParticipants = [...participantIds];
    if (!allParticipants.contains(userId)) {
      allParticipants.add(userId);
    }

    return await FirebaseService.createConversation(
      type: ChatType.group,
      name: name,
      participantIds: allParticipants,
    );
  }

  static Future<void> markMessagesAsRead(String conversationId) async {
    final userId = currentUserId;
    if (userId == null) return;

    await FirebaseService.markMessagesAsRead(
      conversationId: conversationId,
      userId: userId,
    );
  }

  static Future<List<UserModel>> searchUsersInCompany({
    required String query,
    String? companyId,
  }) async {
    final userId = currentUserId;
    if (userId == null) return [];

    // If no company ID provided, get current user's company
    if (companyId == null) {
      final userProfile = await FirebaseService.getUserProfile(userId);
      companyId = userProfile?.companyId;
    }

    if (companyId == null) return [];

    try {
      // Search by name in the same company
      final nameQuery = await _firestore
          .collection('users')
          .where('companyId', isEqualTo: companyId)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .get();

      // Search by position in the same company
      final positionQuery = await _firestore
          .collection('users')
          .where('companyId', isEqualTo: companyId)
          .where('position', isGreaterThanOrEqualTo: query)
          .where('position', isLessThan: '${query}z')
          .get();

      final users = <UserModel>[];
      final userIds = <String>{};

      // Add users from name query
      for (final doc in nameQuery.docs) {
        final user = UserModel.fromJson(doc.data());
        if (user.id != userId && !userIds.contains(user.id)) {
          users.add(user);
          userIds.add(user.id);
        }
      }

      // Add users from position query
      for (final doc in positionQuery.docs) {
        final user = UserModel.fromJson(doc.data());
        if (user.id != userId && !userIds.contains(user.id)) {
          users.add(user);
          userIds.add(user.id);
        }
      }

      return users;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<UserModel>> getCompanyUsers({String? companyId}) async {
    final userId = currentUserId;
    if (userId == null) return [];

    // If no company ID provided, get current user's company
    if (companyId == null) {
      final userProfile = await FirebaseService.getUserProfile(userId);
      companyId = userProfile?.companyId;
    }

    if (companyId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .where('companyId', isEqualTo: companyId)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .where((user) => user.id != userId)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<UserModel>> getManagers({String? companyId}) async {
    final userId = currentUserId;
    if (userId == null) return [];

    // If no company ID provided, get current user's company
    if (companyId == null) {
      final userProfile = await FirebaseService.getUserProfile(userId);
      companyId = userProfile?.companyId;
    }

    if (companyId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .where('companyId', isEqualTo: companyId)
          .where('role', isEqualTo: 'manager')
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .where((user) => user.id != userId)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserModel?> getCurrentUserProfile() async {
    final userId = currentUserId;
    if (userId == null) return null;

    return await FirebaseService.getUserProfile(userId);
  }

  static Stream<UserModel?> getCurrentUserProfileStream() {
    final userId = currentUserId;
    if (userId == null) return Stream.value(null);

    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    });
  }
}