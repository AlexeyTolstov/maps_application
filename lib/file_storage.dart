import 'package:hive_flutter/hive_flutter.dart';

class User {
  final String login;
  final String password;

  User({
    required this.login,
    required this.password,
  });

  @override
  String toString() => "Login: $login Password: $password";
}

class HiveService {
  static const String _boxName = 'userData';
  static late Box<String> box;

  static Future<void> init() async {
    await Hive.initFlutter();
    box = await Hive.openBox<String>(_boxName);
  }

  static Future<void> saveUser(User user) async {
    await box.put('login', user.login);
    await box.put('password', user.password);
  }

  static User? getUser() {
    final String? login = box.get('login');
    final String? password = box.get('password');

    if (login != null && password != null) {
      return User(login: login, password: password);
    }
    return null;
  }

  static Future<void> deleteUser() async {
    await box.delete('login');
    await box.delete('password');
  }
}
