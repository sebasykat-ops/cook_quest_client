import 'package:cook_quest_client/core/config/app_config.dart';
import 'package:cook_quest_client/core/network/api_client.dart';
import 'package:cook_quest_client/features/recipes/application/use_cases/get_recipes_use_case.dart';
import 'package:cook_quest_client/features/recipes/infrastructure/data_sources/http_recipe_data_source.dart';
import 'package:cook_quest_client/features/recipes/infrastructure/repositories/http_recipe_repository.dart';
import 'package:cook_quest_client/features/recipes/presentation/controllers/recipes_controller.dart';

class AppContainer {
  late final ApiClient apiClient;
  late final HttpRecipeDataSource recipeDataSource;
  late final HttpRecipeRepository recipeRepository;
  late final GetRecipesUseCase getRecipesUseCase;
  late final RecipesController recipesController;

  AppContainer() {
    apiClient = ApiClient(baseUrl: AppConfig.apiBaseUrl);
    recipeDataSource = HttpRecipeDataSource(apiClient: apiClient);
    recipeRepository = HttpRecipeRepository(recipeDataSource: recipeDataSource);
    getRecipesUseCase = GetRecipesUseCase(recipeRepository: recipeRepository);
    recipesController = RecipesController(getRecipesUseCase: getRecipesUseCase);
  }
}
