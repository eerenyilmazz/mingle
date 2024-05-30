import 'package:flutter/material.dart';

import '../../data/db/entity/app_user.dart';
import '../../utils/constants.dart';

class ChatTopBar extends StatelessWidget {
  final AppUser user;

  ChatTopBar({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
              barrierColor: kSecondaryColor.withOpacity(0.7),
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
                final screenSize = MediaQuery.of(context).size;
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: kAccentColor, width: 1),
                  ),
                  backgroundColor: kAccentColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: screenSize.height * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(user.profilePhotoPath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user.name}, ${user.age}',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: kPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              user.bio,
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              transitionBuilder: (context, animation, secondaryAnimation, child) {
                final curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                );
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1),
                    end: Offset.zero,
                  ).animate(curvedAnimation),
                  child: child,
                );
              },
            );
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kAccentColor, width: 1.0),
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(user.profilePhotoPath),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: kSecondaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
