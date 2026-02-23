import 'package:cook_quest_client/features/recipes/domain/entities/recipe_entity.dart';
import 'package:cook_quest_client/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:cook_quest_client/features/recipes/infrastructure/data_sources/http_recipe_data_source.dart';
import 'package:cook_quest_client/features/recipes/infrastructure/models/recipe_model.dart';
import 'package:cook_quest_client/features/recipes/infrastructure/schema/get_recipes_response_schema.dart';

class HttpRecipeRepository implements RecipeRepository {
  HttpRecipeRepository({required HttpRecipeDataSource recipeDataSource})
    : _recipeDataSource = recipeDataSource;

  final HttpRecipeDataSource _recipeDataSource;

  @override
  Future<List<RecipeEntity>> getRecipes() async {
    final rawBody = await _recipeDataSource.getRecipes();
    final data = GetRecipesResponseSchema.parse(rawBody);

    return data.map(RecipeModel.fromJson).toList(growable: false);
  }
}
