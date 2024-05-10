import 'package:flutter/material.dart';
import '../utils/form_validator_utils.dart';
import '../widgets/user/primary_button.dart';
import '../widgets/user/text_button.dart';
import '../widgets/user/text_input_field.dart';
import '../widgets/user/widgets.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController fullNameController;
  late TextEditingController ageController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  final _formKey = GlobalKey<FormState>();

  late UserService _userService;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    ageController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    _userService = UserService();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.getAppBar(context, showBackButton: true),
      body: Container(
        height: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _formFields(),
                const SizedBox(height: 50),
                _interactions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formFields() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidgets.pageTitle("Sign Up"),
          const SizedBox(height: 20),
          MyTextInputField(
            title: "Full name",
            hint: "Your full name",
            controller: fullNameController,
            validator: (value) {
              return MyFormValidator.textValidator(value: value, minLength: 3);
            },
          ),
          const SizedBox(height: 20),
          MyTextInputField(
            title: "Age",
            hint: "Your age",
            controller: ageController,
            validator: (value) {
              return MyFormValidator.ageValidator(age: value);
            },
          ),
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
            },
          ),
          const SizedBox(height: 20),
          MyTextInputField(
            title: "Confirm Password",
            hint: "Retype Password",
            isPassword: true,
            controller: confirmPasswordController,
            validator: (value) {
              return MyFormValidator.passwordMatchValidator(
                  password: value,
                  matchTo: passwordController.value.text,
                  minLength: 6);
            },
          ),
        ],
      ),
    );
  }

  Widget _interactions() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          child: PrimaryButton(
            text: "SIGN UP",
            onPressed: () {
              _signUp(); // Calling signup function
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account?"),
            MyTextButton(
              text: "Login",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }

  void _signUp() async {
    if (_formKey.currentState?.validate() == true) {
      String fullName = fullNameController.value.text;
      String email = emailController.value.text;
      String password = passwordController.value.text;


      User? newUser = await _userService.signUp(
        fullName: fullName,
        age: int.parse(ageController.value.text),
        email: email,
        password: password,
      );

      if (newUser != null) {
        // Navigate to home screen or do something else
      } else {
        // Handle signup failure
      }
    }
  }
}
