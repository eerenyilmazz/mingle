import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/db/entity/match.dart';
import '../../../data/db/entity/app_user.dart';
import '../../../data/db/entity/swipe.dart';
import '../../../data/db/remote/firebase_database_source.dart';
import '../../../data/provider/user_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../../widgets/custom_modal_progress_hud.dart';
import '../../widgets/rounded_icon_button.dart';
import '../../widgets/swipe_card.dart';
import '../matched_screen.dart';
import '../../../data/db/entity/chat.dart';
import '../../../data/db/entity/message.dart'; // Message sınıfını import ettik

class MatchScreen extends StatefulWidget {
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _ignoreSwipeIds = [];

  Future<AppUser?> loadPerson(String myUserId) async {
    if (_ignoreSwipeIds.isEmpty) {
      var swipes = await _databaseSource.getSwipes(myUserId);
      _ignoreSwipeIds = swipes.docs.map((doc) => Swipe.fromSnapshot(doc).id).toList();
      _ignoreSwipeIds.add(myUserId);
    }
    var res = await _databaseSource.getPersonsToMatchWith(1, _ignoreSwipeIds);
    if (res.docs.isNotEmpty) {
      var userToMatchWith = AppUser.fromSnapshot(res.docs.first);
      return userToMatchWith;
    } else {
      return null;
    }
  }

  void personSwiped(AppUser myUser, AppUser otherUser, bool isLiked) async {
    _databaseSource.addSwipedUser(myUser.id, Swipe(otherUser.id, isLiked));
    _ignoreSwipeIds.add(otherUser.id);

    if (isLiked == true) {
      if (await isMatch(myUser, otherUser) == true) {
        _databaseSource.addMatch(myUser.id, Match(otherUser.id));
        _databaseSource.addMatch(otherUser.id, Match(myUser.id));
        String chatId = compareAndCombineIds(myUser.id, otherUser.id);
        Message message = Message(DateTime.now().millisecondsSinceEpoch, false, myUser.id, "Hi, let's chat!"); // Mesaj oluşturuldu
        _databaseSource.addChat(Chat(chatId, message)); // Chat oluşturulurken mesaj geçildi

        Navigator.pushNamed(context, MatchedScreen.id, arguments: {
          "my_user_id": myUser.id,
          "my_profile_photo_path": myUser.profilePhotoPath,
          "other_user_profile_photo_path": otherUser.profilePhotoPath,
          "other_user_id": otherUser.id
        });
      }
    }
    setState(() {});
  }

  Future<bool> isMatch(AppUser myUser, AppUser otherUser) async {
    DocumentSnapshot swipeSnapshot = await _databaseSource.getSwipe(otherUser.id, myUser.id);
    if (swipeSnapshot.exists) {
      Swipe swipe = Swipe.fromSnapshot(swipeSnapshot);
      if (swipe.liked == true) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return FutureBuilder<AppUser?>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                return CustomModalProgressHUD(
                  inAsyncCall: userProvider.user == null || userProvider.isLoading,
                  key: UniqueKey(),
                  offset: Offset(0,0),
                  child: (userSnapshot.hasData)
                      ? FutureBuilder<AppUser?>(
                    future: loadPerson(userSnapshot.data!.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data == null) {
                        return Center(
                          child: Container(
                            child: Text('No users', style: Theme.of(context).textTheme.headline4),
                          ),
                        );
                      }
                      if (snapshot.connectionState != ConnectionState.done) {
                        return CustomModalProgressHUD(
                          inAsyncCall: true,
                          key: UniqueKey(),
                          offset: Offset(0,0),
                          child: Container(),
                        );
                      }
                      return Container(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SwipeCard(person: snapshot.data!),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 45),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          RoundedIconButton(
                                            onPressed: () {
                                              personSwiped(userSnapshot.data!, snapshot.data!, false);
                                            },
                                            iconData: Icons.clear,
                                            buttonColor: kColorPrimaryVariant,
                                            iconSize: 30,
                                          ),
                                          RoundedIconButton(
                                            onPressed: () {
                                              personSwiped(userSnapshot.data!, snapshot.data!, true);
                                            },
                                            iconData: Icons.favorite,
                                            iconSize: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                      : Container(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
