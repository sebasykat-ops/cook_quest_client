import 'package:cook_quest_client/features/recipes/domain/entities/recipe_step_entity.dart';

class RecipeStepModel extends RecipeStepEntity {
  RecipeStepModel({
    required super.id,
    required super.recipeId,
    required super.order,
    required super.instruction,
    required super.requiresAdult,
    super.tip,
    super.timerSeconds,
    super.hazard,
  });

  factory RecipeStepModel.fromJson(Map<String, dynamic> json) {
    return RecipeStepModel(
      id: json['id'] as String,
      recipeId: json['recipeId'] as String,
      order: (json['order'] as num).toInt(),
      instruction: json['instruction'] as String,
      tip: json['tip'] as String?,
      timerSeconds: (json['timerSeconds'] as num?)?.toInt(),
      requiresAdult: json['requiresAdult'] as bool,
      hazard: json['hazard'] as String?,
    );
  }
}
