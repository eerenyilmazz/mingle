import 'package:flutter/material.dart';
import 'package:mingle/utils/constants.dart';

import '../../widgets/bordered_text_field.dart';

class NameScreen extends StatelessWidget {
  final Function(String) onChanged;

  const NameScreen({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Column(
            children: [
              Text(
                'My first',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: kAccentColor),
              ),
              Text(
                'name is',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: kAccentColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Expanded(
          child: BorderedTextField(
            labelText: 'Name',
            onChanged: onChanged,
            textCapitalization: TextCapitalization.words,
          ),
        ),
      ],
    );
  }
}
