import '../../domain/entities/recipe_entity.dart';

class RecipeModel extends RecipeEntity {
  RecipeModel({
    required super.id,
    required super.title,
    required super.difficulty,
    required super.totalMinutes,
    required super.requiresAdult,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      difficulty: json['difficulty'] as String,
      totalMinutes: json['totalMinutes'] as int,
      requiresAdult: json['requiresAdult'] as bool,
    );
  }
}
