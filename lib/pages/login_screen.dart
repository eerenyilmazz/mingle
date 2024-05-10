import 'package:flutter/material.dart';
import 'package:mingle/pages/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/form_validator_utils.dart';
import '../widgets/user/primary_button.dart';
import '../widgets/user/text_button.dart';
import '../widgets/user/text_input_field.dart';
import '../widgets/user/widgets.dart';
import 'home_page.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

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
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyHomePage()));
    } catch (e) {
      // Handle login errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                    password: value, minLength: 6);
              }),
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
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  _login();
                }
              }),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?"),
            MyTextButton(
              text: "Sign up",
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignupScreen()));
              },
            ),
          ],
        ),
      ],
    );
  }
}
