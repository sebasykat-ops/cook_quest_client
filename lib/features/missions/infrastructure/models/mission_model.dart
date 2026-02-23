import 'package:cook_quest_client/features/missions/domain/entities/mission_entity.dart';

class MissionModel extends MissionEntity {
  MissionModel({
    required super.id,
    required super.recipeId,
    required super.currentStep,
    required super.isCompleted,
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    final missionId = json['missionId'] as String?;

    if (missionId == null || missionId.isEmpty) {
      throw const FormatException('missionId is missing in response payload');
    }

    return MissionModel(
      id: missionId,
      recipeId: (json['recipeId'] as String?) ?? 'unknown-recipe',
      currentStep: (json['currentStep'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool,
    );
  }
}
