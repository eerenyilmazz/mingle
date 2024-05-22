import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppIconTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 32.0,
            height: 32.0,
          ),
          const SizedBox(width: 5.0),
          Text(
            'Mingle',
            style: Theme.of(context).textTheme.headline2,
          )
        ],
      ),
    );
  }
}
