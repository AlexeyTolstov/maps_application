import 'package:flutter/material.dart';
import 'package:maps_application/api_client.dart';
import 'package:maps_application/data/suggestion.dart';
import 'package:maps_application/pages/main_page.dart';

class AddSuggestionPage extends StatefulWidget {
  const AddSuggestionPage({super.key});

  @override
  State<AddSuggestionPage> createState() => AddSuggestionPageState();
}

class AddSuggestionPageState extends State<AddSuggestionPage> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  String category = suggestionCategories[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Добавить предложение"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                textInputAction: TextInputAction.done,
                controller: controllerName,
                decoration: InputDecoration(
                  hintText: "Название",
                  border: OutlineInputBorder(),
                ),
              ),
              DropdownButton<String>(
                value: category,
                hint: Text("Выберите элемент"),
                items: suggestionCategories.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newCategory) {
                  setState(() {
                    category = newCategory ?? suggestionCategories[0];
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                textInputAction: TextInputAction.done,
                controller: controllerDescription,
                decoration: InputDecoration(
                  hintText: "Описание",
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Suggestion suggestion = Suggestion(
                        name: controllerName.text,
                        description: controllerDescription.text,
                        author_id: myUserId,
                      );

                      addSuggestion(suggestion);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ваше предложение успешно добавлено'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    child: Text("Добавить"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Отмена"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
