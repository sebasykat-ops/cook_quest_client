class RecipeEntity {
  RecipeEntity({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.totalMinutes,
    required this.requiresAdult,
    required this.ingredients,
    required this.utensils,
  });

  final String id;
  final String title;
  final String difficulty;
  final int totalMinutes;
  final bool requiresAdult;
  final List<String> ingredients;
  final List<String> utensils;
}
