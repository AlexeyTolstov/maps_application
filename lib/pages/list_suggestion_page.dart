import 'package:flutter/material.dart';
import 'package:maps_application/api_client.dart';
import 'package:maps_application/widgets/suggestion_item.dart';

class ListSuggestionPage extends StatefulWidget {
  const ListSuggestionPage({super.key});

  @override
  State<ListSuggestionPage> createState() => _ListSuggestionPageState();
}

class _ListSuggestionPageState extends State<ListSuggestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Список предложений"),
      ),
      body: ListView.builder(
        itemCount: allSuggestions.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SuggestionItem(
              title: allSuggestions[index].name,
              description: allSuggestions[index].description,
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
