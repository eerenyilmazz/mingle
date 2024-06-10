import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mingle/utils/constants.dart';

class AppIconTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;
    double imageSize = isSmallScreen ? screenWidth * 0.5 : screenWidth * 0.5;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Image.asset(
            'assets/images/mingle_logo.png',
            height: imageSize,
            width: imageSize,
          ),
      ],
    );
  }
}
