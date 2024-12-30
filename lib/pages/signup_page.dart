import 'package:flutter/material.dart';
import 'package:maps_application/file_storage.dart';
import 'package:maps_application/styles/app_colors.dart';
import 'package:maps_application/styles/font_styles.dart';
import 'package:maps_application/widgets/gosuslugi_button.dart';
import 'package:maps_application/api_client.dart';
import 'package:maps_application/widgets/login_password_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController loginTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  bool isHide = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Зарегистрироваться",
          style: LoginAndSignUpFontStyles.header,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: 300,
                child: InputLoginPassword(
                  loginTextController: loginTextController,
                  passwordTextController: passwordTextController,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: TextButton(
                onPressed: () {
                  bool isValid = ApiClient.createNewUser(
                    loginTextController.text,
                    passwordTextController.text,
                  );
                  if (!isValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Такой логин уже занят'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    HiveService.saveUser(User(
                      login: loginTextController.text,
                      password: passwordTextController.text,
                    )).then((value) =>
                        Navigator.pushReplacementNamed(context, '/main_page'));
                  }
                },
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(
                      LoginColors.loginButtonForegroundColor),
                  backgroundColor: WidgetStateProperty.all(
                      LoginColors.loginButtonBackgroundColor),
                ),
                child: const SizedBox(
                  width: 300,
                  child: Text(
                    "Зарегистрироваться",
                    textAlign: TextAlign.center,
                    style: LoginAndSignUpFontStyles.buttonText,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              "Зарегистрироваться через: ",
              style: LoginAndSignUpFontStyles.pharagraph,
            ),
            Center(
              child: GosuslugiButton(
                onTap: () {
                  print("Click on Gosuslugi");
                },
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(
                      LoginColors.signUpButtonForegroundColor),
                  backgroundColor: WidgetStateProperty.all(
                      LoginColors.signUpButtonBackgroundColor),
                ),
                child: const SizedBox(
                  width: 300,
                  child: Text(
                    "Войти",
                    textAlign: TextAlign.center,
                    style: LoginAndSignUpFontStyles.buttonText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    loginTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }
}
