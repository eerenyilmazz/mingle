import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../entity/app_user.dart';
import '../../provider/user_provider.dart';
import '../entity/event.dart';
import '../entity/ticket.dart';

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

  Future<List<String>> getEventIdsWithUserTickets(String userId) async {
    try {
      QuerySnapshot ticketSnapshot = await _db
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .get();

      Set<String> eventIdsWithTickets = ticketSnapshot.docs.map((doc) => doc['eventId'] as String).toSet();

      return eventIdsWithTickets.toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error getting event IDs with user tickets: $e");
      }
      throw e;
    }
  }

  Future<List<AppUser>> getUsersWithTicketsForEvents(List<String> eventIds) async {
    try {
      List<AppUser> usersWithTickets = [];

      for (String eventId in eventIds) {
        QuerySnapshot<Map<String, dynamic>> ticketSnapshot = await _db
            .collection(_collectionName)
            .where('eventId', isEqualTo: eventId)
            .get();

        Set<String> userIdsWithTickets = ticketSnapshot.docs.map((doc) => doc['userId'] as String).toSet();
        for (String userId in userIdsWithTickets) {
          DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _db.collection('users').doc(userId).get();
          if (userSnapshot.exists) {
            usersWithTickets.add(AppUser.fromSnapshot(userSnapshot));
          }
        }
      }

      return usersWithTickets;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting users with tickets for events: $e");
      }
      throw e;
    }
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

  Future<List<Ticket>> getUserTickets(String userId) async {
    try {
      QuerySnapshot ticketSnapshot = await _db
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .get();

      List<Ticket> userTickets = ticketSnapshot.docs.map((doc) => Ticket.fromSnapshot(doc)).toList();

      return userTickets;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting user's tickets: $e");
      }
      throw e;
    }
  }

}
