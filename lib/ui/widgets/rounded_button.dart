import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  RoundedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: kPrimaryColor, backgroundColor: kAccentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kPrimaryColor)),
      ),
    );
  }
}
