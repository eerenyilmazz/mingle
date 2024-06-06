import 'package:cloud_firestore/cloud_firestore.dart';

import 'event.dart';

class Ticket {
  String userId;
  String userName;
  String eventId;
  String eventName;
  DateTime eventDate;
  String eventLocation;
  num eventPrice;

  Ticket({
    required this.userId,
    required this.userName,
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.eventLocation,
    required this.eventPrice,
  });

  factory Ticket.fromEvent(Event event, String userId, String userName) {
    return Ticket(
      userId: userId,
      userName: userName,
      eventId: event.id,
      eventName: event.name,
      eventDate: event.eventDate,
      eventLocation: event.location,
      eventPrice: event.price,
    );
  }

  factory Ticket.fromSnapshot(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Ticket(
      userId: data['userId'],
      userName: data['userName'],
      eventId: data['eventId'],
      eventName: data['eventName'],
      eventDate: (data['eventDate'] as Timestamp).toDate(),
      eventLocation: data['eventLocation'],
      eventPrice: data['eventPrice'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'eventId': eventId,
      'eventName': eventName,
      'eventDate': eventDate,
      'eventLocation': eventLocation,
      'eventPrice': eventPrice,
    };
  }
}
