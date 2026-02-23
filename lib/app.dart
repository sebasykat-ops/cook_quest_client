import 'package:flutter/material.dart';

import 'package:cook_quest_client/core/di/app_container.dart';
import 'package:cook_quest_client/features/recipes/presentation/pages/recipes_page.dart';

class App extends StatelessWidget {
  const App({super.key, required this.appContainer});

  final AppContainer appContainer;

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF7C3AED);
    const secondaryLavender = Color(0xFFA78BFA);
    const accentMint = Color(0xFF2DD4BF);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryPurple,
      primary: primaryPurple,
      secondary: secondaryLavender,
      tertiary: accentMint,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'CookQuest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF8F5FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF2E1065),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2E1065),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: primaryPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
      home: RecipesPage(
        recipesController: appContainer.recipesController,
        missionControllerFactory: appContainer.createMissionController,
      ),
    );
  }
}
