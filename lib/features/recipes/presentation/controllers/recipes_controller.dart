import 'package:flutter/foundation.dart';

import 'package:cook_quest_client/features/recipes/application/use_cases/get_recipes_use_case.dart';
import 'package:cook_quest_client/features/recipes/domain/entities/recipe_entity.dart';

class RecipesController extends ChangeNotifier {
  RecipesController({required GetRecipesUseCase getRecipesUseCase})
    : _getRecipesUseCase = getRecipesUseCase;

  final GetRecipesUseCase _getRecipesUseCase;

  bool isLoading = false;
  String? errorMessage;
  List<RecipeEntity> recipes = [];

  Future<void> loadRecipes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      recipes = await _getRecipesUseCase.run();
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
