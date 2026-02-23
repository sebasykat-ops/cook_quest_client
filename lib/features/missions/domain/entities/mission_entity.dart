class MissionEntity {
  MissionEntity({
    required this.id,
    required this.recipeId,
    required this.currentStep,
    required this.totalSteps,
    required this.isCompleted,
    required this.completedTimes,
    required this.missionCode,
  });

  final String id;
  final String recipeId;
  final int currentStep;
  final int totalSteps;
  final bool isCompleted;
  final int completedTimes;
  final String missionCode;
}
