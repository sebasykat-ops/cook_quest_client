class MissionStepCompletionEntity {
  MissionStepCompletionEntity({required this.stepOrder, required this.completedAt});

  final int stepOrder;
  final String completedAt;
}

class MissionEntity {
  MissionEntity({
    required this.id,
    required this.recipeId,
    required this.currentStep,
    required this.totalSteps,
    required this.isCompleted,
    required this.completedTimes,
    required this.stepCompletions,
    required this.missionCode,
  });

  final String id;
  final String recipeId;
  final int currentStep;
  final int totalSteps;
  final bool isCompleted;
  final int completedTimes;
  final List<MissionStepCompletionEntity> stepCompletions;
  final String missionCode;
}
