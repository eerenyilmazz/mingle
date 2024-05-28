import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/db/entity/match.dart';
import '../../../data/db/entity/app_user.dart';
import '../../../data/db/entity/swipe.dart';
import '../../../data/db/remote/firebase_database_source.dart';
import '../../../data/db/remote/ticket_service.dart';
import '../../../data/provider/user_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../../widgets/custom_modal_progress_hud.dart';
import '../../widgets/rounded_icon_button.dart';
import '../../widgets/swipe_card.dart';
import '../matched_screen.dart';
import '../../../data/db/entity/chat.dart';
import '../../../data/db/entity/message.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();
  final TicketService _ticketService = TicketService();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _selectedEventId;
  List<String> _eventIdsWithTickets = [];

  @override
  void initState() {
    super.initState();
    _loadUserTickets();
  }

  Future<void> _loadUserTickets() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = await userProvider.user;
    if (user != null) {
      List<String> eventIds = await _ticketService.getEventIdsWithUserTickets(user.id);
      setState(() {
        _eventIdsWithTickets = eventIds;
        if (eventIds.isNotEmpty) {
          _selectedEventId = eventIds[0];
        }
      });
    }
  }

  Future<AppUser?> loadPerson(String myUserId, String eventId) async {
    try {
      // Etkinlikteki diğer katılımcıları al
      List<AppUser> usersWithTickets = await _ticketService.getUsersWithTicketsForEvents([eventId]);

      // Kendi kullanıcı ID'sini filtrele
      usersWithTickets.removeWhere((user) => user.id == myUserId);

      // Kullanıcının daha önce swipe ettiği kişileri filtrele
      List<String> swipedUserIds = await getSwipedUserIds(myUserId);
      usersWithTickets.removeWhere((user) => swipedUserIds.contains(user.id));

      if (usersWithTickets.isNotEmpty) {
        final random = Random();
        final randomIndex = random.nextInt(usersWithTickets.length);
        final userToMatchWith = usersWithTickets[randomIndex];
        return userToMatchWith;
      } else {
        print("Error loading person: No users with tickets found for the event.");
        return null;
      }
    } catch (e) {
      print("Error loading person: $e");
      return null;
    }
  }

  Future<List<String>> getSwipedUserIds(String userId) async {
    QuerySnapshot<Map<String, dynamic>> swipesSnapshot = await _databaseSource.getSwipes(userId);
    return swipesSnapshot.docs.map((doc) => doc['id'] as String).toList();
  }

  void personSwiped(AppUser myUser, AppUser otherUser, bool isLiked) async {
    _databaseSource.addSwipedUser(myUser.id, Swipe(otherUser.id, isLiked));

    if (isLiked) {
      if (await isMatch(myUser, otherUser)) {
        _databaseSource.addMatch(myUser.id, Match(otherUser.id));
        _databaseSource.addMatch(otherUser.id, Match(myUser.id));
        String chatId = compareAndCombineIds(myUser.id, otherUser.id);
        Message message = Message(DateTime.now().millisecondsSinceEpoch, false, myUser.id, "Hi, let's chat!");
        _databaseSource.addChat(Chat(chatId, message));


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
      if (swipe.liked) {
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
                  offset: const Offset(0, 0),
                  child: (userSnapshot.hasData)
                      ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: kPrimaryColor,
                                  ),
                                  child: const Icon(Icons.event, color: kAccentColor),
                                ),
                                const Text(
                                  'Your Tickets',
                                  style: TextStyle(color: kAccentColor, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: kAccentColor),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: kPrimaryColor),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  filled: true,
                                  fillColor: kPrimaryColor,
                                ),
                                value: _selectedEventId,
                                items: _eventIdsWithTickets
                                    .map((eventId) => DropdownMenuItem<String>(
                                  value: eventId,
                                  child: Text(
                                    eventId,
                                    style: const TextStyle(color: kAccentColor),
                                  ),
                                ))
                                    .toList(),
                                onChanged: (newEventId) {
                                  setState(() {
                                    _selectedEventId = newEventId!;
                                  });
                                },
                                dropdownColor: kPrimaryColor,
                                iconEnabledColor: kAccentColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: FutureBuilder<AppUser?>(
                          future: loadPerson(userSnapshot.data!.id, _selectedEventId ?? ''),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.data == null) {
                              return Center(
                                child: Container(
                                  child: Text('No users', style: Theme.of(context).textTheme.headline4?.copyWith(color: kAccentColor)),
                                ),
                              );
                            }
                            if (snapshot.connectionState != ConnectionState.done) {
                              return CustomModalProgressHUD(
                                inAsyncCall: true,
                                key: UniqueKey(),
                                offset: const Offset(0, 0),
                                child: Container(),
                              );
                            }
                            return Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SwipeCard(
                                      person: snapshot.data!,
                                      onSwipeLeft: () {
                                        personSwiped(userSnapshot.data!, snapshot.data!, false);
                                      },
                                      onSwipeRight: () {
                                        personSwiped(userSnapshot.data!, snapshot.data!, true);
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 45.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      RoundedIconButton(
                                        onPressed: () {
                                          personSwiped(userSnapshot.data!, snapshot.data!, false);
                                        },
                                        iconData: Icons.clear,
                                        buttonColor: kAccentColor,
                                        iconSize: 30,
                                      ),
                                      RoundedIconButton(
                                        onPressed: () {
                                          personSwiped(userSnapshot.data!, snapshot.data!, true);
                                        },
                                        iconData: Icons.favorite,
                                        buttonColor: kAccentColor,
                                        iconSize: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),



                    ],
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
