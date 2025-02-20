import 'package:flutter/material.dart';
import 'package:maps_application/file_storage.dart';
import 'package:maps_application/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  HiveService.deleteUser();

  runApp(const MyApp());
}
