import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_models.dart';
import '../models/user_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth methods
  static User? get currentUser => _auth.currentUser;
  
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Firestore collections
  static CollectionReference get users => _firestore.collection('users');
  static CollectionReference get companies => _firestore.collection('companies');
  static CollectionReference get attendance => _firestore.collection('attendance');
  static CollectionReference get conversations => _firestore.collection('conversations');
  static CollectionReference get messages => _firestore.collection('messages');

  // User management
  static Future<void> createUserProfile({
    required String uid,
    required String email,
    required String name,
    required UserRole role,
    String? companyId,
    String? position,
  }) async {
    final userModel = UserModel(
      id: uid,
      email: email,
      name: name,
      role: role,
      companyId: companyId,
      position: position,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await users.doc(uid).set(userModel.toJson());
  }

  static Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await users.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Chat methods
  static Stream<List<ChatConversation>> getConversations(String userId) {
    return conversations
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatConversation.fromFirestore(doc))
            .toList());
  }

  static Stream<List<ChatMessage>> getMessages(String conversationId) {
    return messages
        .where('conversationId', isEqualTo: conversationId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromFirestore(doc))
            .toList());
  }

  static Future<String> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String text,
    MessageType type = MessageType.text,
    String? imageUrl,
    String? fileUrl,
    String? fileName,
    String? senderRole,
  }) async {
    final message = ChatMessage(
      id: '',
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      text: text,
      type: type,
      timestamp: DateTime.now(),
      imageUrl: imageUrl,
      fileUrl: fileUrl,
      fileName: fileName,
      senderRole: senderRole,
    );

    final docRef = await messages.add(message.toFirestore());
    
    // Update conversation's last message
    await conversations.doc(conversationId).update({
      'lastMessage': text,
      'lastMessageTime': Timestamp.fromDate(DateTime.now()),
      'lastMessageSenderId': senderId,
    });

    return docRef.id;
  }

  static Future<String> createConversation({
    required ChatType type,
    required String name,
    required List<String> participantIds,
    String? avatar,
  }) async {
    final conversation = ChatConversation(
      id: '',
      type: type,
      name: name,
      avatar: avatar,
      participantIds: participantIds,
      lastMessage: 'Conversation started',
      lastMessageTime: DateTime.now(),
      lastMessageSenderId: participantIds.first,
      createdAt: DateTime.now(),
    );

    final docRef = await conversations.add(conversation.toFirestore());
    return docRef.id;
  }

  static Future<void> markMessagesAsRead({
    required String conversationId,
    required String userId,
  }) async {
    final batch = _firestore.batch();
    
    final unreadMessages = await messages
        .where('conversationId', isEqualTo: conversationId)
        .where('senderId', isNotEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  static Future<List<UserModel>> searchUsers({
    required String query,
    String? excludeUserId,
  }) async {
    try {
      final snapshot = await users
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .where((user) => user.id != excludeUserId)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}