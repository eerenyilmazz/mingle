import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/db/remote/firebase_auth_source.dart';
import '../../data/provider/user_provider.dart';
import '../../ui/screens/top_navigation_screen.dart';
import '../../utils/constants.dart';
import '../widgets/bordered_text_field.dart';
import '../widgets/custom_modal_progress_hud.dart';
import '../widgets/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

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
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  void loginPressed() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('Giriş işlemi başlatıldı.');
      var response = await _userProvider.loginUser(_inputEmail, _inputPassword, _scaffoldKey);
      print('Giriş işlemi tamamlandı.');

      if (response is AuthSuccess<UserCredential>) {
        if (mounted) {
          print('Giriş başarılı, kullanıcı yönlendiriliyor.');
          Navigator.of(context)
              .pushNamedAndRemoveUntil(TopNavigationScreen.id, (route) => false);
        }
      } else {
        print('Giriş başarısız: ${response}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Giriş işlemi sırasında hata oluştu: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş sırasında bir hata oluştu. Lütfen tekrar deneyin.')),
      );
    }
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
          offset: const Offset(0, 0),
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
