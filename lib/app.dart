import 'package:flutter/material.dart';

import 'package:cook_quest_client/core/di/app_container.dart';
import 'package:cook_quest_client/features/recipes/presentation/pages/recipes_page.dart';

class App extends StatelessWidget {
  const App({super.key, required this.appContainer});

  final AppContainer appContainer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CookQuest',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange), useMaterial3: true),
      home: RecipesPage(
        recipesController: appContainer.recipesController,
        missionControllerFactory: appContainer.createMissionController,
      ),
    );
  }
}
