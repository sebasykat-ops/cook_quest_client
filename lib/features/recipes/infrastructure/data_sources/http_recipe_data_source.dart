import 'package:cook_quest_client/core/network/api_client.dart';

class HttpRecipeDataSource {
  HttpRecipeDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<dynamic> getRecipes() async {
    final response = await _apiClient.dio.get('/recipes');
    return response.data;
  }

  Future<dynamic> getRecipeSteps(String recipeId) async {
    final response = await _apiClient.dio.get('/recipes/$recipeId/steps');
    return response.data;
  }
}
