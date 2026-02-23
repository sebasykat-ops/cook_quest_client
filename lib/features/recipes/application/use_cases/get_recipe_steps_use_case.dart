import 'package:cook_quest_client/features/recipes/domain/entities/recipe_step_entity.dart';
import 'package:cook_quest_client/features/recipes/domain/repositories/recipe_repository.dart';

class GetRecipeStepsUseCase {
  GetRecipeStepsUseCase({required RecipeRepository recipeRepository}) : _recipeRepository = recipeRepository;

  final RecipeRepository _recipeRepository;

  Future<List<RecipeStepEntity>> run(String recipeId) {
    return _recipeRepository.getRecipeSteps(recipeId);
  }
}
