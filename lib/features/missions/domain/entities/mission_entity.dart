class MissionEntity {
  MissionEntity({
    required this.id,
    required this.recipeId,
    required this.currentStep,
    required this.totalSteps,
    required this.isCompleted,
  });

  final String id;
  final String recipeId;
  final int currentStep;
  final int totalSteps;
  final bool isCompleted;
}
