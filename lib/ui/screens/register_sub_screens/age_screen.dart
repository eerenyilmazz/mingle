import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../utils/constants.dart';

class AgeScreen extends StatefulWidget {
  final Function(num) onChanged;

  AgeScreen({required this.onChanged});

  @override
  _AgeScreenState createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  int age = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: kAccentColor),
              ),
              Text(
                'age is',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: kAccentColor),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              child: NumberPicker(
                  textStyle: const TextStyle(color: kSecondaryColor),
                  itemWidth: double.infinity,
                  selectedTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kAccentColor),
                  decoration: BoxDecoration(
                    border: Border.all(color: kColorPrimaryVariant, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  value: age,
                  minValue: 0,
                  maxValue: 120,
                  onChanged: (value) => {
                        setState(() {
                          age = value;
                        }),
                        widget.onChanged(value)
                      }),
            ),
          ),
        ),
      ],
    );
  }
}
