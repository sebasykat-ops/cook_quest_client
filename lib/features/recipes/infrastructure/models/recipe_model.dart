import 'package:cook_quest_client/features/recipes/domain/entities/recipe_entity.dart';

class RecipeModel extends RecipeEntity {
  RecipeModel({
    required super.id,
    required super.title,
    required super.difficulty,
    required super.totalMinutes,
    required super.requiresAdult,
    required super.ingredients,
    required super.utensils,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      difficulty: json['difficulty'] as String,
      totalMinutes: (json['totalMinutes'] as num).toInt(),
      requiresAdult: json['requiresAdult'] as bool,
      ingredients: (json['ingredients'] as List<dynamic>? ?? const []).map((item) => item.toString()).toList(),
      utensils: (json['utensils'] as List<dynamic>? ?? const []).map((item) => item.toString()).toList(),
    );
  }
}
