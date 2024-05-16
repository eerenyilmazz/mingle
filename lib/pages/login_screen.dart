import 'package:flutter/material.dart';
import 'package:mingle/pages/signup_screen.dart';
import '../services/user_service.dart';
import '../utils/form_validator_utils.dart';
import '../widgets/user/primary_button.dart';
import '../widgets/user/text_button.dart';
import '../widgets/user/text_input_field.dart';
import '../widgets/user/widgets.dart';
import 'home_page.dart';
import '../models/user_model.dart' as CustomUser;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();
  bool _isLoading = false;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;
      });

      CustomUser.User? user = await _userService.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
      if (user != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ));
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppWidgets.getAppBar(context),
        body: Container(
          height: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  formFields(),
                  const SizedBox(height: 50),
                  _interactions(),
                  _isLoading ? const CircularProgressIndicator() : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget formFields() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidgets.pageTitle("Login"),
          const SizedBox(height: 20),
          MyTextInputField(
            title: "E-mail",
            hint: "Your email id",
            controller: emailController,
            validator: (value) {
              return MyFormValidator.emailValidator(emailId: value);
            },
          ),
          const SizedBox(height: 20),
          MyTextInputField(
            title: "Password",
            hint: "Password",
            isPassword: true,
            controller: passwordController,
            validator: (value) {
              return MyFormValidator.passwordValidator(
                password: value,
                minLength: 6,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _interactions() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(""),
            MyTextButton(
              text: "Forgot Password?",
              onPressed: () {
                // Add forgot password logic
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          child: PrimaryButton(
            text: "LOGIN",
            onPressed: _login,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?"),
            MyTextButton(
              text: "Sign up",
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SignupScreen(),
                ));
              },
            ),
          ],
        ),
      ],
    );
  }
}