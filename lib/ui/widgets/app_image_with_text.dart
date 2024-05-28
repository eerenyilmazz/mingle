import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mingle/utils/constants.dart';

class AppIconTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Mingle',
          style: Theme.of(context).textTheme.headline2?.copyWith(color: kAccentColor),
        )
      ],
    );
  }
}
