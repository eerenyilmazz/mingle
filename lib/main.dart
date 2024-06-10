import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mingle/ui/screens/chat_screen.dart';
import 'package:mingle/ui/screens/login_screen.dart';
import 'package:mingle/ui/screens/matched_screen.dart';
import 'package:mingle/ui/screens/register_screen.dart';
import 'package:mingle/ui/screens/splash_screen.dart';
import 'package:mingle/ui/screens/start_screen.dart';
import 'package:mingle/ui/screens/top_navigation_screen.dart';
import 'package:mingle/utils/constants.dart';
import 'package:provider/provider.dart';

import 'data/provider/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: kAccentColor));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: kFontFamily,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: const MaterialColor(kBackgroundColorInt, kThemeMaterialColor),
          ).copyWith(
            secondary: kPrimaryColor,
            onSecondary: kSecondaryColor,
            onPrimary: kAccentColor,
          ),
          scaffoldBackgroundColor: kPrimaryColor,
          hintColor: kColorPrimaryVariant,
          textTheme: const TextTheme(
            displaySmall: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headlineMedium: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            headlineSmall: TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ).apply(
            bodyColor: kSecondaryColor,
            displayColor: kPrimaryColor,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: kPrimaryColor, backgroundColor: kAccentColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => const SplashScreen(),
          StartScreen.id: (context) => const StartScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) => const RegisterScreen(),
          TopNavigationScreen.id: (context) => TopNavigationScreen(),
          MatchedScreen.id: (context) => MatchedScreen(
            myProfilePhotoPath: (ModalRoute.of(context)?.settings.arguments
            as Map)['my_profile_photo_path'],
            myUserId: (ModalRoute.of(context)?.settings.arguments
            as Map)['my_user_id'],
            otherUserProfilePhotoPath: (ModalRoute.of(context)
                ?.settings
                .arguments as Map)['other_user_profile_photo_path'],
            otherUserId: (ModalRoute.of(context)?.settings.arguments
            as Map)['other_user_id'],
          ),
          ChatScreen.id: (context) => ChatScreen(
            chatId: (ModalRoute.of(context)?.settings.arguments
            as Map)['chat_id'],
            otherUserId: (ModalRoute.of(context)?.settings.arguments
            as Map)['other_user_id'],
            myUserId: (ModalRoute.of(context)?.settings.arguments
            as Map)['user_id'],
          ),
        },
      ),
    );
  }
}
