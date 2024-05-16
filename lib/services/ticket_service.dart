import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mingle/services/user_service.dart';
import '../models/event_model.dart';
import '../models/ticket_model.dart';
import '../models/user_model.dart' as CustomUser;
import '../models/user_model.dart';

class TicketService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionName = 'tickets';
  final UserService _userService = UserService();

  Future<bool> userHasTicket(User user, Event event) async {
    try {
      QuerySnapshot ticketSnapshot = await _db
          .collection(_collectionName)
          .where('userId', isEqualTo: user.uid)
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

  Future<void> buyTicket(User user, Event event) async {
    try {
      bool hasTicket = await userHasTicket(user, event);
      if (hasTicket) {
        if (kDebugMode) {
          print('User already has a ticket for this event.');
        }
        return;
      }

      CustomUser.User? currentUser = await _userService.getCurrentUser();
      if (currentUser != null) {
        Ticket ticket = Ticket(
          userId: currentUser.uid,
          userName: currentUser.fullName,
          userEmail: currentUser.email,
          eventId: event.id,
          eventName: event.name,
          eventDate: event.eventDate,
          eventLocation: event.location,
          eventPrice: event.price,
        );

        await _db.collection(_collectionName).add(ticket.toMap());
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error buying ticket: $e");
      }
    }
  }
}
