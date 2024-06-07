import 'package:flutter/material.dart';
import 'package:mingle/utils/constants.dart';

class RoundedIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  final double iconSize;
  final double paddingReduce;
  final Color? buttonColor;
  final Color? iconColor; // Icon color
  final Color borderColor;
  final double borderWidth;

  const RoundedIconButton({
    super.key, // key parameter added
    required this.onPressed,
    required this.iconData,
    this.iconSize = 30,
    this.buttonColor,
    this.iconColor, // Icon color
    this.paddingReduce = 0,
    this.borderColor = kPrimaryColor,
    this.borderWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = buttonColor ?? theme.buttonTheme.colorScheme?.background ?? theme.colorScheme.primary;
    const Color iconColorFinal = kPrimaryColor; // Icon color

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
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
        child: Icon(iconData, size: iconSize, color: iconColorFinal), // Icon color
      ),
    );
  }
}
