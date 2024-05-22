import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/db/entity/app_user.dart';
import '../../data/provider/user_provider.dart';
import '../../utils/utils.dart';
import '../widgets/portrait.dart';
import '../widgets/rounded_button.dart';
import '../widgets/rounded_outlined_button.dart';
import 'chat_screen.dart';


class MatchedScreen extends StatelessWidget {
  static const String id = 'matched_screen';

  final String myProfilePhotoPath;
  final String myUserId;
  final String otherUserProfilePhotoPath;
  final String otherUserId;

  MatchedScreen(
      {super.key, required this.myProfilePhotoPath,
      required this.myUserId,
      required this.otherUserProfilePhotoPath,
      required this.otherUserId});

  void sendMessagePressed(BuildContext context) async {
    AppUser? user = await Provider.of<UserProvider>(context, listen: false).user;

    Navigator.pop(context);
    Navigator.pushNamed(context, ChatScreen.id, arguments: {
      "chat_id": compareAndCombineIds(myUserId, otherUserId),
      "user_id": user?.id,
      "other_user_id": otherUserId
    });
  }

  void keepSwipingPressed(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 42.0,
            horizontal: 18.0,
          ),
          margin: const EdgeInsets.only(bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Portrait(imageUrl: myProfilePhotoPath),
                  Portrait(imageUrl: otherUserProfilePhotoPath)
                ],
              ),
              const SizedBox(height: 80),
              Column(
                children: [
                  RoundedButton(
                      text: 'SEND MESSAGE',
                      onPressed: () {
                        sendMessagePressed(context);
                      }),
                  const SizedBox(height: 20),
                  RoundedButton(
                      text: 'KEEP SWIPING',
                      onPressed: () {
                        keepSwipingPressed(context);
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
