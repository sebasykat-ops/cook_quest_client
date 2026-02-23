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
      appBar: AppBar(title: const Text('CookQuest Recipes')),
      body: Builder(
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

          return ListView.builder(
            itemCount: recipesController.recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipesController.recipes[index];

              return RecipeTile(
                recipe: recipe,
                wasCompletedBefore: recipesController.isRecipeCompleted(recipe.id),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MissionPage(
                        recipeTitle: recipe.title,
                        missionId: 'mission-1',
                        missionController: widget.missionControllerFactory(),
                        onRecipeCompleted: () => recipesController.markRecipeCompleted(recipe.id),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
