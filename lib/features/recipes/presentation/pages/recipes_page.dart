import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../data/repositories/http_recipe_repository.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../../missions/presentation/pages/mission_page.dart';
import '../widgets/recipe_tile.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  late final HttpRecipeRepository _recipeRepository;
  late Future<List<RecipeEntity>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    final apiClient = ApiClient(baseUrl: 'http://localhost:3000');
    _recipeRepository = HttpRecipeRepository(apiClient: apiClient);
    _recipesFuture = _recipeRepository.getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CookQuest Recipes')),
      body: FutureBuilder<List<RecipeEntity>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading recipes: ${snapshot.error}'),
            );
          }

          final recipes = snapshot.data ?? [];

          if (recipes.isEmpty) {
            return const Center(child: Text('No recipes available'));
          }

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return RecipeTile(
                recipe: recipe,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MissionPage(recipeTitle: recipe.title),
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
