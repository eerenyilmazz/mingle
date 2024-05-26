import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class TicketDropdown extends StatelessWidget {
  final List<String> eventIdsWithTickets;
  final String? selectedEventId;
  final void Function(String?) onChanged;

  const TicketDropdown({super.key,
    required this.eventIdsWithTickets,
    required this.selectedEventId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kAccentColor),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kPrimaryColor),
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: kPrimaryColor,
        ),
        value: selectedEventId,
        items: eventIdsWithTickets
            .map((eventId) => DropdownMenuItem<String>(
          value: eventId,
          child: Text(
            eventId,
            style: const TextStyle(color: kAccentColor),
          ),
        ))
            .toList(),
        onChanged: onChanged,
        dropdownColor: kPrimaryColor,
        iconEnabledColor: kAccentColor,
      ),
    );
  }
}
