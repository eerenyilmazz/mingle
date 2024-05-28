import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/db/entity/app_user.dart';
import '../../../data/model/chat_with_user.dart';
import '../../../data/provider/user_provider.dart';
import '../../../utils/constants.dart';
import '../../widgets/chats_list.dart';
import '../../widgets/custom_modal_progress_hud.dart';
import '../chat_screen.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  void chatWithUserPressed(ChatWithUser chatWithUser) async {
    AppUser? user = await Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      Navigator.pushNamed(context, ChatScreen.id, arguments: {
        "chat_id": chatWithUser.chat.id,
        "user_id": user.id,
        "other_user_id": chatWithUser.user.id
      });
    } else {
      // Handle case where user is null
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Text(
                'Your Matches',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: kAccentColor,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return FutureBuilder<AppUser?>(
                    future: userProvider.user,
                    builder: (context, userSnapshot) {
                      return CustomModalProgressHUD(
                        inAsyncCall:
                        userSnapshot.data == null || userProvider.isLoading,
                        key: UniqueKey(),
                        offset: const Offset(0,0),
                        child: (userSnapshot.hasData && userSnapshot.data != null)
                            ? FutureBuilder<List<ChatWithUser>>(
                            future: userProvider
                                .getChatsWithUser(userSnapshot.data!.id),
                            builder: (context, chatWithUsersSnapshot) {
                              if (chatWithUsersSnapshot.data == null &&
                                  chatWithUsersSnapshot.connectionState !=
                                      ConnectionState.done) {
                                return CustomModalProgressHUD(
                                    inAsyncCall: true, key: UniqueKey(),
                                    offset: const Offset(0,0),
                                    child: Container());
                              } else {
                                return (chatWithUsersSnapshot.data != null && chatWithUsersSnapshot.data!.length == 0)
                                    ? Center(
                                  child: Container(
                                      child: Text('No matches',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4?.copyWith(color: kAccentColor))),
                                )
                                    : ChatsList( // Define ChatsList widget
                                  chatWithUserList:
                                  chatWithUsersSnapshot.data!,
                                  onChatWithUserTap: chatWithUserPressed,
                                  myUserId: userSnapshot.data!.id,
                                );
                              }
                            })
                            : Container(),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}