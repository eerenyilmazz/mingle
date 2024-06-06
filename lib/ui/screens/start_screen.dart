import 'package:flutter/material.dart';
import 'package:mingle/ui/screens/register_screen.dart';
import 'package:mingle/ui/screens/login_screen.dart';
import '../../utils/constants.dart';
import '../widgets/app_image_with_text.dart';
import '../widgets/rounded_button.dart';


class StartScreen extends StatelessWidget {
  static const String id = 'start_screen';

  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: kDefaultPadding,
          child: Container(
            margin: const EdgeInsets.only(bottom: 40, top: 120),
            child: Column(
              children: [
                AppIconTitle(),
                Expanded(child: Container()),
                Text(
                  "Join events with Mingle and meet brand new people! Don't wait any longer to "
                      "dive into exciting moments and have a great time. Start expanding your social circle now!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 60),
                RoundedButton(
                    text: 'CREATE ACCOUNT',
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RegisterScreen.id);
                    }),
                const SizedBox(height: 20),
                RoundedButton(
                  text: 'LOGIN',
                  onPressed: () => Navigator.pushNamed(context, LoginScreen.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
