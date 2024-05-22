import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String name;
  String description;
  DateTime eventDate;
  String image;
  String location;
  String organizer;
  num price;

  Event({
    required this.id,
    required this.eventDate,
    required this.image,
    required this.location,
    required this.name,
    required this.organizer,
    required this.price,
    required this.description,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      name: data['name'],
      description: data['description'],
      eventDate: (data['eventDate'] as Timestamp).toDate(),
      image: data['image'],
      location: data['location'],
      organizer: data['organizer'],
      price: data['price'],
    );
  }
}
