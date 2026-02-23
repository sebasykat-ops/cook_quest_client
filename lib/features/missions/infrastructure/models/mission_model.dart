import 'package:cook_quest_client/features/missions/domain/entities/mission_entity.dart';

class MissionModel extends MissionEntity {
  MissionModel({
    required super.id,
    required super.recipeId,
    required super.currentStep,
    required super.totalSteps,
    required super.isCompleted,
  });

  factory MissionModel.fromGetMissionByIdJson(Map<String, dynamic> json) {
    return MissionModel(
      id: json['id'] as String,
      recipeId: (json['recipeId'] as String?) ?? 'unknown-recipe',
      currentStep: (json['currentStep'] as num).toInt(),
      totalSteps: (json['totalSteps'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool,
    );
  }

  factory MissionModel.fromAdvanceMissionStepJson(
    Map<String, dynamic> json, {
    required String fallbackRecipeId,
  }) {
    return MissionModel(
      id: json['missionId'] as String,
      recipeId: fallbackRecipeId,
      currentStep: (json['currentStep'] as num).toInt(),
      totalSteps: (json['totalSteps'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool,
    );
  }
}
