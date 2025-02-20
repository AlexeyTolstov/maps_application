import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(title),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}
