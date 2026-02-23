import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cook_quest_client/features/recipes/application/use_cases/get_recipes_use_case.dart';
import 'package:cook_quest_client/features/recipes/domain/entities/recipe_entity.dart';

class RecipesController extends ChangeNotifier {
  RecipesController({required GetRecipesUseCase getRecipesUseCase})
    : _getRecipesUseCase = getRecipesUseCase;

  static const _completedRecipesKey = 'completed_recipe_ids';

  final GetRecipesUseCase _getRecipesUseCase;

  bool isLoading = false;
  String? errorMessage;
  List<RecipeEntity> recipes = [];
  Set<String> completedRecipeIds = {};

  Future<void> loadRecipes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      recipes = await _getRecipesUseCase.run();
      await _loadCompletedRecipes();
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isRecipeCompleted(String recipeId) {
    return completedRecipeIds.contains(recipeId);
  }

  Future<void> markRecipeCompleted(String recipeId) async {
    completedRecipeIds.add(recipeId);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_completedRecipesKey, completedRecipeIds.toList(growable: false));
    notifyListeners();
  }

  Future<void> _loadCompletedRecipes() async {
    final preferences = await SharedPreferences.getInstance();
    completedRecipeIds = (preferences.getStringList(_completedRecipesKey) ?? []).toSet();
  }
}
