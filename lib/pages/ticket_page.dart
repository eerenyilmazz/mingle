import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../utils/datetime_utils.dart';

class TicketPageDialog extends StatelessWidget {
  final Ticket ticket;

  const TicketPageDialog({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Your Ticket Informations',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: screenSize.width * 0.06,
        ),
      ),
      content: SizedBox(
        width: screenSize.width * 0.8,
        height: screenSize.height * 0.30,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: screenSize.height * 0.01),
                child: _textDescription("Ticket Id", ticket.eventId, screenSize),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: screenSize.height * 0.01),
                child: _textDescription("Event Name", ticket.eventName, screenSize),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: screenSize.height * 0.01),
                child: _textDescription("Event Date", DateTimeUtils.getFullDate(ticket.eventDate), screenSize),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: screenSize.height * 0.01),
                child: _textDescription("Event Location", ticket.eventLocation, screenSize),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: screenSize.height * 0.01),
                child: _textDescription("Event Price", '\$${ticket.eventPrice}', screenSize),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textDescription(String title, dynamic value, Size screenSize) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: screenSize.width * 0.04, color: Colors.grey),
      ),
      SizedBox(height: screenSize.height * 0.002),
      Text(
        value.toString(),
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: screenSize.width * 0.045),
      ),
    ],
  );
}
