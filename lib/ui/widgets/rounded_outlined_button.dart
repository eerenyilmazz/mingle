import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class RoundedOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed; // Change the type to VoidCallback

  RoundedOutlinedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: OutlinedButton( // Changed from OutlineButton to OutlinedButton
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: kSecondaryColor, width: 2.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}
