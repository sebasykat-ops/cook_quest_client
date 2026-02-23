import 'package:cook_quest_client/features/missions/domain/entities/mission_entity.dart';

class MissionModel extends MissionEntity {
  MissionModel({
    required super.id,
    required super.recipeId,
    required super.currentStep,
    required super.isCompleted,
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      id: json['missionId'] as String,
      recipeId: (json['recipeId'] as String?) ?? 'unknown-recipe',
      currentStep: json['currentStep'] as int,
      isCompleted: json['isCompleted'] as bool,
    );
  }
}
