import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../entity/app_user.dart';
import '../../provider/user_provider.dart';
import '../../model/event_model.dart';
import '../../model/ticket_model.dart';

class TicketService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionName = 'tickets';
  final UserProvider _userProvider = UserProvider();

  Future<AppUser?> getCurrentUser() async {
    return await _userProvider.user;
  }

  Future<bool> userHasTicket(AppUser user, Event event) async {
    try {
      QuerySnapshot ticketSnapshot = await _db
          .collection(_collectionName)
          .where('userId', isEqualTo: user.id)
          .where('eventId', isEqualTo: event.id)
          .get();

      return ticketSnapshot.docs.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print("Error checking user's ticket: $e");
      }
      return false;
    }
  }

  Future<void> buyTicket(Event event) async {
    try {
      AppUser? currentUser = await getCurrentUser();
      if (currentUser != null) {
        bool hasTicket = await userHasTicket(currentUser, event);
        if (hasTicket) {
          if (kDebugMode) {
            print('User already has a ticket for this event.');
          }
          return;
        }

        Ticket ticket = Ticket.fromEvent(event, currentUser.id, currentUser.name);

        await _db.collection(_collectionName).add(ticket.toMap());
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error buying ticket: $e");
      }
    }
  }

  Future<bool> hasTicketForEvent(Event event) async {
    try {
      AppUser? currentUser = await getCurrentUser();
      if (currentUser != null) {
        return await userHasTicket(currentUser, event);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error checking ticket for event: $e");
      }
    }
    return false;
  }
  Future<List<AppUser>> getUsersWithTickets() async {
    try {
      QuerySnapshot ticketSnapshot = await _db.collection(_collectionName).get();

      Set<String> userIdsWithTickets = ticketSnapshot.docs.map((doc) => doc['userId'] as String).toSet();

      QuerySnapshot usersSnapshot = await _db.collection('users').get();

      List<AppUser> usersWithTickets = usersSnapshot.docs
          .map((doc) => AppUser.fromSnapshot(doc))
          .where((user) => userIdsWithTickets.contains(user.id))
          .toList();

      return usersWithTickets;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting users with tickets: $e");
      }
      return [];
    }
  }

  Future<List<AppUser>> getUsersWithEventTicket(Event event) async {
    try {
      QuerySnapshot ticketSnapshot = await _db
          .collection(_collectionName)
          .where('eventId', isEqualTo: event.id)
          .get();

      Set<String> userIdsWithEventTicket = ticketSnapshot.docs.map((doc) => doc['userId'] as String).toSet();

      QuerySnapshot usersSnapshot = await _db.collection('users').get();

      List<AppUser> usersWithEventTicket = usersSnapshot.docs
          .map((doc) => AppUser.fromSnapshot(doc))
          .where((user) => userIdsWithEventTicket.contains(user.id))
          .toList();

      return usersWithEventTicket;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting users with event ticket: $e");
      }
      return [];
    }
  }

}
