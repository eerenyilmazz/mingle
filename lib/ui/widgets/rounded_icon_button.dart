import 'package:flutter/material.dart';
import 'package:mingle/utils/constants.dart';

class RoundedIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  final double iconSize;
  final double paddingReduce;
  final Color? buttonColor;
  final Color borderColor; // New parameter for border color
  final double borderWidth; // New parameter for border width

  const RoundedIconButton({super.key,
    required this.onPressed,
    required this.iconData,
    this.iconSize = 30,
    this.buttonColor,
    this.paddingReduce = 0,
    this.borderColor = kPrimaryColor, // Default border color is primary color
    this.borderWidth = 4.0, // Default border width is 1.0
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = buttonColor ?? theme.buttonTheme.colorScheme?.background ?? theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor, // Border color
          width: borderWidth, // Border width
        ),
      ),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: 0,
        elevation: 5,
        color: color,
        onPressed: onPressed,
        padding: EdgeInsets.all((iconSize / 2) - paddingReduce),
        shape: const CircleBorder(),
        child: Icon(iconData, size: iconSize),
      ),
    );
  }
}
