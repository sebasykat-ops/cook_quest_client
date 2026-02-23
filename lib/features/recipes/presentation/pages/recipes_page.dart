import 'package:flutter/material.dart';

import 'package:cook_quest_client/features/missions/presentation/controllers/mission_controller.dart';
import 'package:cook_quest_client/features/missions/presentation/pages/mission_page.dart';
import 'package:cook_quest_client/features/recipes/presentation/controllers/recipes_controller.dart';
import 'package:cook_quest_client/features/recipes/presentation/widgets/recipe_tile.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({
    super.key,
    required this.recipesController,
    required this.missionControllerFactory,
  });

  final RecipesController recipesController;
  final MissionController Function() missionControllerFactory;

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  void initState() {
    super.initState();
    widget.recipesController.addListener(_onStateChanged);
    widget.recipesController.loadRecipes();
  }

  @override
  void dispose() {
    widget.recipesController.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipesController = widget.recipesController;

    return Scaffold(
      appBar: AppBar(title: const Text('CookQuest ✨')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F5FF), Color(0xFFEDE9FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Builder(
          builder: (context) {
            if (recipesController.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (recipesController.errorMessage != null) {
              return Center(child: Text('Error loading recipes: ${recipesController.errorMessage}'));
            }

            if (recipesController.recipes.isEmpty) {
              return const Center(child: Text('No recipes available'));
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFF6D28D9),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hora de cocinar! 👩‍🍳👨‍🍳',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Elige una misión, sigue los pasos y gana experiencia.',
                        style: TextStyle(color: Color(0xFFE9D5FF)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...recipesController.recipes.map((recipe) {
                  return RecipeTile(
                    recipe: recipe,
                    wasCompletedBefore: recipesController.isRecipeCompleted(recipe.id),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MissionPage(
                            recipeTitle: recipe.title,
                            missionId: 'mission-${recipe.id}',
                            missionController: widget.missionControllerFactory(),
                            onRecipeCompleted: () => recipesController.markRecipeCompleted(recipe.id),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
