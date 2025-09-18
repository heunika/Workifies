import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/chat_models.dart';
import '../models/user_model.dart';
import '../models/company_model.dart';
import '../models/attendance_model.dart';
import 'dart:math';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

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
    await _googleSignIn.signOut();
  }

  // Google Sign-In
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User canceled the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  // Forgot Password
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // Email Verification
  static Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
    } catch (e) {
      rethrow;
    }
  }

  static bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

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

  // Company management
  static String _generateCompanyCode() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(Iterable.generate(
      6, (_) => chars.codeUnitAt(random.nextInt(chars.length))
    ));
  }

  static Future<String> createCompany({
    required String name,
    required String industry,
    required int yearFounded,
    required String managerId,
    String? logoUrl,
  }) async {
    final companyCode = _generateCompanyCode();

    final company = CompanyModel(
      id: '',
      name: name,
      logoUrl: logoUrl,
      industry: industry,
      yearFounded: yearFounded,
      companyCode: companyCode,
      managerId: managerId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final docRef = await companies.add(company.toJson());

    // Update user with company ID
    await users.doc(managerId).update({
      'companyId': docRef.id,
      'updatedAt': DateTime.now().toIso8601String(),
    });

    return docRef.id;
  }

  static Future<CompanyModel?> getCompanyById(String companyId) async {
    try {
      final doc = await companies.doc(companyId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return CompanyModel.fromJson(data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  static Future<CompanyModel?> getCompanyByCode(String companyCode) async {
    try {
      final querySnapshot = await companies
          .where('companyCode', isEqualTo: companyCode)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return CompanyModel.fromJson(data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> joinCompany({
    required String userId,
    required String companyId,
  }) async {
    try {
      await users.doc(userId).update({
        'companyId': companyId,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<UserModel>> getCompanyEmployees(String companyId) async {
    try {
      final querySnapshot = await users
          .where('companyId', isEqualTo: companyId)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Attendance management
  static Future<String> clockIn({
    required String userId,
    required String companyId,
    double? latitude,
    double? longitude,
    String? address,
  }) async {
    final attendance = AttendanceModel(
      id: '',
      userId: userId,
      companyId: companyId,
      clockInTime: DateTime.now(),
      clockInLatitude: latitude,
      clockInLongitude: longitude,
      clockInAddress: address,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final docRef = await FirebaseFirestore.instance
        .collection('attendance')
        .add(attendance.toJson());

    return docRef.id;
  }

  static Future<void> clockOut({
    required String attendanceId,
    double? latitude,
    double? longitude,
    String? address,
  }) async {
    final clockOutTime = DateTime.now();

    // Get the attendance record to calculate total hours
    final doc = await attendance.doc(attendanceId).get();
    if (!doc.exists) throw Exception('Attendance record not found');

    final data = doc.data() as Map<String, dynamic>;
    final clockInTime = DateTime.parse(data['clockInTime']);
    final totalHours = clockOutTime.difference(clockInTime);

    await attendance.doc(attendanceId).update({
      'clockOutTime': clockOutTime.toIso8601String(),
      'clockOutLatitude': latitude,
      'clockOutLongitude': longitude,
      'clockOutAddress': address,
      'totalHours': totalHours.inMicroseconds,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  static Future<AttendanceModel?> getTodayAttendance(String userId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    try {
      final querySnapshot = await attendance
          .where('userId', isEqualTo: userId)
          .where('clockInTime', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('clockInTime', isLessThanOrEqualTo: endOfDay.toIso8601String())
          .orderBy('clockInTime', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return AttendanceModel.fromJson(data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<AttendanceModel>> getUserAttendance({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = attendance.where('userId', isEqualTo: userId);

      if (startDate != null) {
        query = query.where('clockInTime', isGreaterThanOrEqualTo: startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.where('clockInTime', isLessThanOrEqualTo: endDate.toIso8601String());
      }

      final querySnapshot = await query
          .orderBy('clockInTime', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return AttendanceModel.fromJson(data);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<AttendanceModel>> getCompanyAttendance({
    required String companyId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = attendance.where('companyId', isEqualTo: companyId);

      if (startDate != null) {
        query = query.where('clockInTime', isGreaterThanOrEqualTo: startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.where('clockInTime', isLessThanOrEqualTo: endDate.toIso8601String());
      }

      final querySnapshot = await query
          .orderBy('clockInTime', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return AttendanceModel.fromJson(data);
      }).toList();
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

  // Push Notifications
  static Future<void> initializeNotifications() async {
    try {
      // Request permission for iOS
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }

      // Get FCM token
      String? token = await _messaging.getToken();
      if (token != null) {
        await _saveTokenToDatabase(token);
      }

      // Listen to token refresh
      _messaging.onTokenRefresh.listen(_saveTokenToDatabase);
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  static Future<void> _saveTokenToDatabase(String token) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'fcmToken': token,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
    } catch (e) {
      print('Error unsubscribing from topic: $e');
    }
  }

  static Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Get user's FCM token
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();

      if (userData != null && userData['fcmToken'] != null) {
        // In a real app, you would use a cloud function or your backend
        // to send notifications via FCM Admin SDK
        // This is just a placeholder for the notification structure
        final notification = {
          'to': userData['fcmToken'],
          'notification': {
            'title': title,
            'body': body,
          },
          'data': data ?? {},
        };

        // You would send this to FCM endpoint
        print('Notification ready to send: $notification');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  static Future<void> sendNotificationToCompany({
    required String companyId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Send notification to all company members
      final companyUsers = await getCompanyEmployees(companyId);

      for (final user in companyUsers) {
        await sendNotificationToUser(
          userId: user.id,
          title: title,
          body: body,
          data: data,
        );
      }
    } catch (e) {
      print('Error sending company notification: $e');
    }
  }

  // Handle background messages
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
  }

  // Configure foreground notifications
  static void configureForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // Show local notification or update UI
      }
    });
  }

  // Handle notification tap
  static void configureNotificationTap() {
    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
      // Navigate to appropriate screen based on message data
    });
  }
}