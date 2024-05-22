import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/event_model.dart';

class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionName = 'events';

  Future<List<Event>> getUpcomingEvents(DateTime endDate) async {
    QuerySnapshot querySnapshot = await _db.collection(_collectionName)
        .where('eventDate', isLessThan: endDate)
        .get();
    return querySnapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
  }

  Future<List<Event>> getNearbyEvents() async {
    QuerySnapshot querySnapshot = await _db.collection(_collectionName).get();
    return querySnapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
  }
}


