import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mingle/ui/screens/top_navigation_screen.dart';
import 'package:provider/provider.dart';

import '../../data/db/remote/firebase_storage_source.dart';
import '../../data/provider/user_provider.dart';
import '../../utils/constants.dart';
import '../widgets/bordered_text_field.dart';
import '../widgets/custom_modal_progress_hud.dart';
import '../widgets/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _inputEmail = '';
  String _inputPassword = '';
  bool _isLoading = false;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of(context, listen: false);
  }

  void loginPressed() async {
    setState(() {
      _isLoading = true;
    });
    await _userProvider
        .loginUser(_inputEmail, _inputPassword, _scaffoldKey)
        .then((response) {
      if (response is Success<UserCredential>) {
        Navigator.of(context).pushNamedAndRemoveUntil(TopNavigationScreen.id, (route) => false);
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: CustomModalProgressHUD(
          inAsyncCall: _isLoading,
          key: UniqueKey(),
          offset: Offset(0,0),
          child: Padding(
            padding: kDefaultPadding,
            child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login to your account',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(height: 40),
                  BorderedTextField(
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => _inputEmail = value,
                  ),
                  const SizedBox(height: 5),
                  BorderedTextField(
                    labelText: 'Password',
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    onChanged: (value) => _inputPassword = value,
                  ),
                  Expanded(child: Container()),
                  RoundedButton(text: 'LOGIN', onPressed: () => loginPressed())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
