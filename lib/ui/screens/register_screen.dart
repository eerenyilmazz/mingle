import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../data/db/remote/firebase_storage_source.dart';
import '../../data/provider/user_provider.dart';
import '../../data/model/user_registration.dart';
import '../../ui/screens/register_sub_screens/add_photo_screen.dart';
import '../../ui/screens/register_sub_screens/age_screen.dart';
import '../../ui/screens/register_sub_screens/email_and_password_screen.dart';
import '../../ui/screens/register_sub_screens/name_screen.dart';
import '../../ui/screens/start_screen.dart';
import '../../ui/screens/top_navigation_screen.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../widgets/custom_modal_progress_hud.dart';
import '../widgets/rounded_button.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final UserRegistration _userRegistration = UserRegistration();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final double _endScreenIndex = 3;
  double _currentScreenIndex = 0;
  bool _isLoading = false;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  void registerUser() async {
    setState(() {
      _isLoading = true;
    });

    await _userProvider.registerUser(_userRegistration, _scaffoldKey).then((response) {
      if (response is Success) {
        Navigator.pushNamedAndRemoveUntil(context, TopNavigationScreen.id, (route) => false);
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }


  void goBackPressed() {
    if (_currentScreenIndex == 0) {
      Navigator.pop(context);
      Navigator.pushNamed(context, StartScreen.id);
    } else {
      setState(() {
        _currentScreenIndex--;
      });
    }
  }

  Widget getSubScreen() {
    switch (_currentScreenIndex.toInt()) {
      case 0:
        return NameScreen(onChanged: (value) => _userRegistration.name = value);
      case 1:
        return AgeScreen(onChanged: (value) {
          _userRegistration.age = value.toInt();
        });
      case 2:
        return AddPhotoScreen(onPhotoChanged: (value) => _userRegistration.localProfilePhotoPath = value);
      case 3:
        return EmailAndPasswordScreen(
          emailOnChanged: (value) => _userRegistration.email = value,
          passwordOnChanged: (value) => _userRegistration.password = value,
        );
      default:
        return Container();
    }
  }

  bool canContinueToNextSubScreen() {
    switch (_currentScreenIndex.toInt()) {
      case 0:
        return _userRegistration.name.length >= 2;
      case 1:
        return _userRegistration.age >= 13 && _userRegistration.age <= 120;
      case 2:
        return _userRegistration.localProfilePhotoPath.isNotEmpty;
      default:
        return false;
    }
  }

  String getInvalidRegistrationMessage() {
    switch (_currentScreenIndex.toInt()) {
      case 0:
        return 'Name is too short';
      case 1:
        return 'Invalid age';
      case 2:
        return 'Invalid photo';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: AppBar
          (
          title: const Text('Register'),
        backgroundColor: kPrimaryColor,),
        body: CustomModalProgressHUD(
          inAsyncCall: _isLoading,
          key: UniqueKey(),
          child: Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                Container(
                  child: LinearPercentIndicator(
                    lineHeight: 5,
                    percent: _currentScreenIndex / _endScreenIndex,
                    progressColor: kAccentColor,
                    padding: EdgeInsets.zero,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: kDefaultPadding.copyWith(
                      left: kDefaultPadding.left / 2.0,
                      right: 0.0,
                      bottom: 4.0,
                      top: 4.0,
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(0.0),
                      icon: Icon(
                        _currentScreenIndex == 0 ? Icons.clear : Icons.arrow_back,
                        color: kSecondaryColor,
                        size: 42.0,
                      ),
                      onPressed: goBackPressed,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: getSubScreen(),
                    padding: kDefaultPadding.copyWith(top: 0, bottom: 0),
                  ),
                ),
                Container(
                  padding: kDefaultPadding,
                  child: _currentScreenIndex == _endScreenIndex
                      ? RoundedButton(
                    text: 'REGISTER',
                    onPressed: _isLoading == false ? registerUser : () {},
                  )
                      : RoundedButton(
                    text: 'CONTINUE',
                    onPressed: () {
                      if (canContinueToNextSubScreen()) {
                        setState(() {
                          _currentScreenIndex++;
                        });
                      } else {
                        showSnackBar(
                          _scaffoldKey.currentContext!,
                          getInvalidRegistrationMessage(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
