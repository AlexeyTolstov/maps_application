import 'package:flutter/material.dart';
import 'package:maps_application/file_storage.dart';
import 'package:maps_application/pages/login_page.dart';
import 'package:maps_application/pages/main_page.dart';
import 'package:maps_application/pages/signup_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String initialRoute() {
    User? user = HiveService.getUser();
    return (user == null) ? '/login' : '/main_page';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute(),
      // initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/main_page': (context) => const MainPage(),
      },
    );
  }
}
