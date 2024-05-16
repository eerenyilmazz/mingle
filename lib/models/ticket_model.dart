class Ticket {
  final String userId;
  final String userName;
  final String userEmail;
  final String eventId;
  final String eventName;
  final DateTime eventDate;
  final String eventLocation;
  final num eventPrice;

  Ticket({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.eventLocation,
    required this.eventPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'eventId': eventId,
      'eventName': eventName,
      'eventDate': eventDate,
      'eventLocation': eventLocation,
      'eventPrice': eventPrice,
    };
  }
}