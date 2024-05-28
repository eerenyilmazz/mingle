import 'package:flutter/material.dart';
import '../../data/model/ticket_model.dart';
import '../../utils/datetime_utils.dart';

class TicketPageDialog extends StatelessWidget {
  final Ticket ticket;

  const TicketPageDialog({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Ticket Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenSize.width * 0.06,
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            _ticketInfo("Ticket Id", ticket.eventId, screenSize),
            _ticketInfo("Event Name", ticket.eventName, screenSize),
            _ticketInfo("Event Date", DateTimeUtils.getFullDate(ticket.eventDate), screenSize),
            _ticketInfo("Event Location", ticket.eventLocation, screenSize),
            _ticketInfo("Event Price", '\$${ticket.eventPrice}', screenSize),
          ],
        ),
      ),
    );
  }

  Widget _ticketInfo(String title, dynamic value, Size screenSize) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: screenSize.width * 0.04, color: Colors.grey),
      ),
      SizedBox(height: screenSize.height * 0.005),
      Text(
        value.toString(),
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: screenSize.width * 0.045),
      ),
      SizedBox(height: screenSize.height * 0.015),
      Divider(color: Colors.grey[300], thickness: 1.0),
      SizedBox(height: screenSize.height * 0.015),
    ],
  );
}
