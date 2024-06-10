import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../data/db/entity/app_user.dart';
import '../../../data/db/entity/ticket.dart';
import '../../../data/db/remote/ticket_service.dart';
import '../../../data/provider/user_provider.dart';
import '../../../utils/constants.dart';
import '../../widgets/custom_modal_progress_hud.dart';
import '../../widgets/input_dialog.dart';
import '../../widgets/rounded_button.dart';
import '../../widgets/rounded_icon_button.dart';
import '../start_screen.dart';
import '../ticket_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void logoutPressed(UserProvider userProvider, BuildContext context) async {
    userProvider.logoutUser();
    Navigator.pop(context);
    Navigator.pushNamed(context, StartScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      body: CustomModalProgressHUD(
        inAsyncCall: context.watch<UserProvider>().isLoading,
        key: UniqueKey(),
        child: FutureBuilder<AppUser?>(
          future: context.watch<UserProvider>().user,
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator(color: kAccentColor,));
            }
            AppUser user = userSnapshot.data!;
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  height: height / 3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kPrimaryColor, kAccentColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: kPrimaryColor,
                                width: 4.0,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePhotoPath),
                              radius: MediaQuery.of(context).size.width / 6,
                              backgroundColor: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(user.profilePhotoPath),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0.0,
                            bottom: 0.0,
                            child: RoundedIconButton(
                              onPressed: () async {
                                final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  context.read<UserProvider>().updateUserProfilePhoto(pickedFile.path, _scaffoldKey);
                                }
                              },
                              iconData: Icons.edit,
                              buttonColor: kAccentColor,
                              iconSize: width / 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${user.name}, ${user.age}',
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: ListView(
                      children: [
                        SizedBox(height: height * 0.02),
                        const Divider(color: kAccentColor),
                        SizedBox(height: height * 0.02),
                        getBioSection(user, context.watch<UserProvider>(), width),
                        SizedBox(height: height * 0.02),
                        const Divider(color: kAccentColor),
                        SizedBox(height: height * 0.02),
                        getTicketsSection(context, width, user.id),
                        SizedBox(height: height * 0.02),
                        const Divider(color: kAccentColor),
                        SizedBox(height: height * 0.02),
                        RoundedButton(
                          text: 'LOGOUT',
                          onPressed: () {
                            logoutPressed(context.read<UserProvider>(), context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

  }


  Widget getBioSection(AppUser user, UserProvider userProvider, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.person, size: width / 15, color: kAccentColor),
                SizedBox(width: width * 0.02),
                Text('Biography', style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            RoundedIconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => InputDialog(
                    onSavePressed: (value) => userProvider.updateUserBio(value),
                    labelText: 'Biography',
                    startInputText: user.bio,
                  ),
                );
              },
              iconData: Icons.edit,
              iconSize: width / 20,
              buttonColor: kAccentColor,
              paddingReduce: 4,
            ),
          ],
        ),
        SizedBox(height: width * 0.03),
        Text(
          user.bio.isNotEmpty ? user.bio : "No bio available.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kSecondaryColor)
        ),
      ],
    );
  }

  Widget getTicketsSection(BuildContext context, double width, String userId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.event, size: width / 15, color: kAccentColor),
                SizedBox(width: width * 0.02),
                Text('My Tickets', style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            RoundedIconButton(
              onPressed: () async {
                List<Ticket> tickets = await TicketService().getUserTickets(userId);
                if (tickets.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(
                        'Select Ticket',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kAccentColor, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: const BorderSide(color: kAccentColor, width: 2.0),
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            ...tickets.map((ticket) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (_) => TicketPageDialog(ticket: ticket),
                                      );
                                    },
                                    child: Text(
                                      ticket.eventName,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (_) => TicketPageDialog(ticket: ticket),
                                      );
                                    },
                                    child: Text(
                                      "Click for details",
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kColorPrimaryVariant, fontSize: 14),
                                    ),
                                  ),
                                  const Divider(color: kAccentColor, thickness: 2.0),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    )

                  );
                }
              },
              iconData: Icons.padding_outlined,
              buttonColor: kAccentColor,
              iconSize: width / 20,
              paddingReduce: 4,
            ),
          ],
        ),
        SizedBox(height: width * 0.03),
        FutureBuilder<List<Ticket>>(
          future: TicketService().getUserTickets(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<String> eventNames = snapshot.data!.map((ticket) => ticket.eventName).toList();
              String allEventNames = eventNames.join(" , ");
              return GestureDetector(
                onTap: () {
                },
                child: Text(
                  "You have tickets for $allEventNames. Enjoy the event!",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kSecondaryColor),
                ),
              );
            } else {
              return Text(
                "You don't have a ticket yet. Check out the events suitable for you on the homepage to purchase a ticket.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kSecondaryColor),
              );
            }
          },
        ),
      ],
    );
  }
}