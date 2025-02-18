import 'package:flutter/material.dart';
import 'package:maps_application/file_storage.dart';
import 'package:maps_application/styles/app_colors.dart';
import 'package:maps_application/styles/font_styles.dart';
import 'package:maps_application/widgets/auth/gosuslugi_button.dart';
import 'package:maps_application/api_client.dart';
import 'package:maps_application/widgets/auth/ok_button.dart';
import 'package:maps_application/widgets/auth/vk_button.dart';
import 'package:maps_application/widgets/signin_password_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController loginTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SignUpAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Форма для регистрации
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

            /// Кнопка "Зарегистрироваться"
            Center(
              child: TextButton(
                onPressed: signUpValidation,
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

            /// Кнопка "войти" - переход на страницу входа
            Center(
              child: TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/sign-in'),
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

            /// Вход через соцсети
            const SizedBox(height: 50),
            const Text(
              "Зарегистрироваться через: ",
              style: LoginAndSignUpFontStyles.pharagraph,
            ),

            /// Войти через госуслуги
            Center(
              child: GosuslugiButton(
                onTap: () => Navigator.pushNamed(context, '/sign-in/gosuslugi'),
              ),
            ),

            /// ОК и ВК
            Center(
              child: Row(
                children: [
                  OKButton(
                    onTap: () => Navigator.pushNamed(context, '/sign-in/ok'),
                  ),
                  SizedBox(width: 50),
                  VKButton(
                    onTap: () => Navigator.pushNamed(context, '/sign-in/vk'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar SignUpAppBar() {
    return AppBar(
      title: const Text(
        "Зарегистрироваться",
        style: LoginAndSignUpFontStyles.header,
      ),
    );
  }

  @override
  void dispose() {
    loginTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  void signUpValidation() {
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
      )).then((value) => Navigator.pushReplacementNamed(context, '/maps_page'));
    }
  }
}
