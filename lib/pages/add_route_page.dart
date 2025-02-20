import 'package:flutter/material.dart';

class AddRoutePage extends StatefulWidget {
  const AddRoutePage({super.key});

  @override
  State<AddRoutePage> createState() => _AddRoutePageState();
}

class _AddRoutePageState extends State<AddRoutePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Добавить маршрут"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Text(
          'Вкладка "Добавить маршрут" еще не работает. \nПриходите, когда она заработает >_<',
        ),
      ),
    );
  }
}
