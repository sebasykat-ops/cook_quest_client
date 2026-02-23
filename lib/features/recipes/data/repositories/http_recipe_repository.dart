import '../../../../core/network/api_client.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../models/recipe_model.dart';

class HttpRecipeRepository implements RecipeRepository {
  HttpRecipeRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<RecipeEntity>> getRecipes() async {
    final response = await _apiClient.dio.get('/recipes');
    final data = response.data['data'] as List<dynamic>;

    return data
        .map((item) => RecipeModel.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
}
