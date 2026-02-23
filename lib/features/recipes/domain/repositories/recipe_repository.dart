import 'package:cook_quest_client/features/recipes/domain/entities/recipe_entity.dart';

abstract class RecipeRepository {
  Future<List<RecipeEntity>> getRecipes();
}
