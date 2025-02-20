import 'package:flutter/material.dart';

class Tutorial {
  BuildContext context;
  Tutorial(this.context);

  void showTutorialDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Добро пожаловать!"),
        content: Text(
            "Хотите пройти небольшое обучение по использованию приложения?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Нет, я все знаю"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _tutorial1();
            },
            child: Text("Да"),
          ),
        ],
      ),
    );
  }

  void _tutorial1() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        title: Text(
          "Обучение",
          style: TextStyle(color: Colors.white),
        ),
        content: Container(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Text(
              style: TextStyle(color: Colors.white),
              "Если хотите добавить точку с описанием, просто нажмите в нужное место, введите текст – и готово!",
            ),
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white)),
            onPressed: () {
              Navigator.pop(context);
              _tutorial2();
            },
            child: Text("Дальше ->"),
          ),
        ],
      ),
    );
  }

  void _tutorial2() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        title: Text(
          "Обучение",
          style: TextStyle(color: Colors.white),
        ),
        content: Container(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Text(
              style: TextStyle(color: Colors.white),
              "Чтобы построить маршрут или добавить предложение, откройте меню в верхнем правом углу.",
            ),
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white)),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Завершить!"),
          ),
        ],
      ),
    );
  }
}
