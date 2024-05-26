import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed; // Change to VoidCallback

  RoundedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton( // Change RaisedButton to ElevatedButton
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: kAccentColor, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        child: Text(text, style: Theme.of(context).textTheme.button?.copyWith(color: kPrimaryColor)),
      ),
    );
  }
}
