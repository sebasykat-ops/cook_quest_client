class RecipeStepEntity {
  RecipeStepEntity({
    required this.id,
    required this.recipeId,
    required this.order,
    required this.instruction,
    required this.requiresAdult,
    this.tip,
    this.timerSeconds,
    this.hazard,
  });

  final String id;
  final String recipeId;
  final int order;
  final String instruction;
  final String? tip;
  final int? timerSeconds;
  final bool requiresAdult;
  final String? hazard;
}
