import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../data/db/entity/app_user.dart';
import '../data/provider/user_provider.dart';
import '../models/event_model.dart';
import '../models/ticket_model.dart';

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
}
