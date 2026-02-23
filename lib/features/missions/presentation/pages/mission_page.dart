import 'package:flutter/material.dart';

class MissionPage extends StatelessWidget {
  const MissionPage({super.key, required this.recipeTitle});

  final String recipeTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Misión: $recipeTitle')),
      body: const Center(
        child: Text('Pantalla inicial de misión (próximo sprint).'),
      ),
    );
  }
}
