import 'package:flutter/material.dart';
import 'package:maps_application/widgets/menu_item.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Меню"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            MenuItem(
              title: "Добавить предложение",
              description: "",
              onTap: () => Navigator.pushNamed(context, '/add_suggestion'),
            ),
            SizedBox(height: 20),
            MenuItem(
              title: "Список предложений",
              description: "",
              onTap: () => Navigator.pushNamed(context, '/list_suggestion'),
            ),
            SizedBox(height: 20),
            MenuItem(
              title: "Создать маршрут",
              description: "",
              onTap: () => Navigator.pushNamed(context, '/add_route'),
            ),
          ],
        ),
      ),
    );
  }
}
