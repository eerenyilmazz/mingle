import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../data/db/entity/app_user.dart';
import '../../../data/model/event_model.dart';
import '../../../data/provider/user_provider.dart';
import '../../../utils/constants.dart';
import '../../widgets/custom_modal_progress_hud.dart';
import '../../widgets/input_dialog.dart';
import '../../widgets/rounded_button.dart';
import '../../widgets/rounded_icon_button.dart';
import '../start_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late Event event;


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
        offset: const Offset(0,0),
        child: FutureBuilder<AppUser?>(
          future: context.watch<UserProvider>().user,
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
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
                                color: kPrimaryColor, // Border color set to kPrimaryColor
                                width: 4.0, // Adjust the border width as desired
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePhotoPath),
                              radius: MediaQuery.of(context).size.width / 6, // Using MediaQuery to get screen width
                              backgroundColor: Colors.transparent, // Transparent background for the CircleAvatar
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover, // Cover fit for the image inside the circle
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
                          fontWeight: FontWeight.bold, // Add this line to make the text bold
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
                        const Divider(color: kAccentColor), // Divider with kAccentColor
                        SizedBox(height: height * 0.02),
                        getBioSection(user, context.watch<UserProvider>(), width),
                        SizedBox(height: height * 0.02),
                        const Divider(color: kAccentColor), // Divider with kAccentColor
                        SizedBox(height: height * 0.02),
                        getTicketsSection(context, width),
                        SizedBox(height: height * 0.02),
                        const Divider(color: kAccentColor), // Divider with kAccentColor
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
                Text('Biography', style: Theme.of(context).textTheme.titleLarge),
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
              paddingReduce: 4,
            ),
          ],
        ),
        SizedBox(height: width * 0.03),
        Text(
          user.bio.isNotEmpty ? user.bio : "No bio available.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget getTicketsSection(BuildContext context, double width) {
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
                Text('My Tickets', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            RoundedIconButton(
              onPressed: () {
              },
              iconData: Icons.padding_outlined,
              iconSize: width / 20,
              paddingReduce: 4,
            ),

          ],
        ),
        SizedBox(height: width * 0.03),
        // Placeholder for the tickets list or details
        Text(
          "You have no tickets at the moment.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

}
