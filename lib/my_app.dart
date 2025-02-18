import 'package:flutter/material.dart';
import 'package:maps_application/file_storage.dart';
import 'package:maps_application/pages/auth/signin_gosuslugi.dart';
import 'package:maps_application/pages/auth/signin_ok_page.dart';
import 'package:maps_application/pages/auth/signin_page.dart';
import 'package:maps_application/pages/auth/signin_vk_page.dart';
import 'package:maps_application/pages/main_page.dart';
import 'package:maps_application/pages/auth/signup_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String initialRoute() {
    User? user = HiveService.getUser();
    return (user == null) ? '/sign-in' : '/maps_page';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute(),
      routes: {
        '/sign-in': (context) => const SignInPage(),
        '/sign-in/vk': (context) => const SignInVKPage(),
        '/sign-in/ok': (context) => const SignInOKPage(),
        '/sign-in/gosuslugi': (context) => const SignInGosuslugiPage(),
        '/sign-up': (context) => const SignUpPage(),
        '/maps_page': (context) => const MainPage(),
      },
    );
  }
}
