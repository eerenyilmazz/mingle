import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mingle/utils/constants.dart';

import '../../widgets/image_portrait.dart';
import '../../widgets/rounded_icon_button.dart';

class AddPhotoScreen extends StatefulWidget {
  final Function(String) onPhotoChanged;

  const AddPhotoScreen({super.key, required this.onPhotoChanged});

  @override
  _AddPhotoScreenState createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  final picker = ImagePicker();
  String _imagePath = '';

  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      widget.onPhotoChanged(pickedFile.path);

      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Add photo',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(color: kAccentColor),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Stack(
                    children: [
                      Container(
                        child: _imagePath.isEmpty
                            ? ImagePortrait(imageType: ImageType.NONE)
                            : ImagePortrait(
                          imagePath: _imagePath,
                          imageType: ImageType.FILE_IMAGE,
                        ),
                      ),
                      if (_imagePath.isEmpty)
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: RoundedIconButton(
                              onPressed: pickImageFromGallery,
                              iconData: Icons.add,
                              iconSize: 20,
                              buttonColor: kAccentColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
