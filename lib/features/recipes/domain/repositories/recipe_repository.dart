import 'package:cook_quest_client/features/recipes/domain/entities/recipe_entity.dart';
import 'package:cook_quest_client/features/recipes/domain/entities/recipe_step_entity.dart';

abstract class RecipeRepository {
  Future<List<RecipeEntity>> getRecipes();
  Future<List<RecipeStepEntity>> getRecipeSteps(String recipeId);
}
