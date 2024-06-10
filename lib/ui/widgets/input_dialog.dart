import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'bordered_text_field.dart';

class InputDialog extends StatefulWidget {
  final String labelText;
  final Function(String) onSavePressed;
  final String startInputText;

  @override
  _InputDialogState createState() => _InputDialogState();

  InputDialog({
    required this.labelText,
    required this.onSavePressed,
    this.startInputText = '',
  });
}

class _InputDialogState extends State<InputDialog> {
  String inputText = '';
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text = widget.startInputText;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kPrimaryColor,
      contentPadding: const EdgeInsets.all(16.0),
      content: BorderedTextField(
        textCapitalization: TextCapitalization.sentences,
        labelText: widget.labelText,
        autoFocus: true,
        keyboardType: TextInputType.text,
        onChanged: (value) => {inputText = value},
        textController: textController,
      ),
      actions: <Widget>[
        TextButton(

          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kAccentColor),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'CANCEL',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kPrimaryColor),
          ),
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kAccentColor),
          ),
          onPressed: () {
            widget.onSavePressed(inputText);
            Navigator.pop(context);
          },
          child: Text(
            'SAVE',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kPrimaryColor),
          ),
        ),

      ],
    );
  }
}
