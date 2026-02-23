class RecipeEntity {
  RecipeEntity({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.totalMinutes,
    required this.requiresAdult,
  });

  final String id;
  final String title;
  final String difficulty;
  final int totalMinutes;
  final bool requiresAdult;
}
