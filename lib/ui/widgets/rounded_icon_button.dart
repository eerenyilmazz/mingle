import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  final double iconSize;
  final double paddingReduce;
  final Color? buttonColor;

  RoundedIconButton({
    required this.onPressed,
    required this.iconData,
    this.iconSize = 30,
    this.buttonColor,
    this.paddingReduce = 0,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = buttonColor ?? theme.buttonTheme.colorScheme?.background ?? theme.colorScheme.primary;

    return MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minWidth: 0,
      elevation: 5,
      color: color,
      onPressed: onPressed,
      padding: EdgeInsets.all((iconSize / 2) - paddingReduce),
      shape: const CircleBorder(),
      child: Icon(iconData, size: iconSize),
    );
  }
}
