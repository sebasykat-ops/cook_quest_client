class MissionEntity {
  MissionEntity({
    required this.id,
    required this.recipeId,
    required this.currentStep,
    required this.isCompleted,
  });

  final String id;
  final String recipeId;
  final int currentStep;
  final bool isCompleted;
}
