import 'package:cook_quest_client/features/recipes/domain/entities/recipe_entity.dart';
import 'package:cook_quest_client/features/recipes/domain/repositories/recipe_repository.dart';

class GetRecipesUseCase {
  GetRecipesUseCase({required RecipeRepository recipeRepository})
    : _recipeRepository = recipeRepository;

  final RecipeRepository _recipeRepository;

  Future<List<RecipeEntity>> run() {
    return _recipeRepository.getRecipes();
  }
}
