import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../entity/app_user.dart';
import '../entity/chat.dart';
import '../entity/message.dart';
import '../entity/swipe.dart';
import '../entity/match.dart';

class FirebaseDatabaseSource {
  final FirebaseFirestore instance = FirebaseFirestore.instance;

  void addUser(AppUser user) {
    if (kDebugMode) {
      print('Adding user: ${user.id}');
    }
    instance.collection('users').doc(user.id).set(user.toMap());
  }

  void addMatch(String userId, Match match) {
    print('Adding match for user $userId: ${match.id}');
    instance
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(match.id)
        .set(match.toMap());
  }

  void addChat(Chat chat) {
    print('Adding chat: ${chat.id}');
    instance.collection('chats').doc(chat.id).set(chat.toMap());
  }

  void addMessage(String chatId, Message message) {
    print('Adding message to chat $chatId');
    instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
  }

  void addSwipedUser(String userId, Swipe swipe) {
    print('Adding swipe for user $userId: ${swipe.id}');
    instance
        .collection('users')
        .doc(userId)
        .collection('swipes')
        .doc(swipe.id)
        .set(swipe.toMap());
  }

  void updateUser(AppUser user) async {
    print('Updating user: ${user.id}');
    instance.collection('users').doc(user.id).update(user.toMap());
  }

  void updateChat(Chat chat) {
    print('Updating chat: ${chat.id}');
    instance.collection('chats').doc(chat.id).update(chat.toMap());
  }

  void updateMessage(String chatId, String messageId, Message message) {
    print('Updating message in chat $chatId: $messageId');
    instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update(message.toMap());
  }
  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String userId) {
    return instance.collection('users').doc(userId).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getSwipe(
      String userId, String swipeId) {
    return instance
        .collection('users')
        .doc(userId)
        .collection('swipes')
        .doc(swipeId)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMatches(String userId) {
    return instance
        .collection('users')
        .doc(userId)
        .collection('matches')
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getChat(String chatId) {
    return instance.collection('chats').doc(chatId).get();
  }


  Future<QuerySnapshot<Map<String, dynamic>>> getPersonsToMatchWith(String eventId) async {
    QuerySnapshot<Map<String, dynamic>> ticketsQuerySnapshot = await instance.collection('tickets').where('eventId', isEqualTo: eventId).get();
    List userIds = ticketsQuerySnapshot.docs.map((doc) => doc.data()['userId']).toList();
    return instance.collection('users').where('id', whereIn: userIds).get();
  }


  Future<QuerySnapshot<Map<String, dynamic>>> getSwipes(String userId) {
    return instance.collection('users').doc(userId).collection('swipes').get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> observeUser(String userId) {
    return instance.collection('users').doc(userId).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> observeMessages(String chatId) {
    return instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('epoch_time_ms', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> observeChat(String chatId) {
    return instance.collection('chats').doc(chatId).snapshots();
  }
}
