import 'package:flutter/material.dart';

import 'package:cook_quest_client/features/recipes/domain/entities/recipe_entity.dart';

class RecipeTile extends StatelessWidget {
  const RecipeTile({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.wasCompletedBefore,
  });

  final RecipeEntity recipe;
  final VoidCallback onTap;
  final bool wasCompletedBefore;

  @override
  Widget build(BuildContext context) {
    final difficultyLabel = switch (recipe.difficulty) {
      'easy' => 'Fácil',
      'medium' => 'Media',
      'hard' => 'Difícil',
      _ => recipe.difficulty,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF3E8FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('🍽️', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xFF2E1065),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$difficultyLabel • ${recipe.totalMinutes} min',
                        style: const TextStyle(color: Color(0xFF6D28D9)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (wasCompletedBefore)
                  const Tooltip(
                    message: '¡Ya completaste esta receta!',
                    child: Icon(Icons.emoji_events_rounded, color: Colors.amber),
                  ),
                const SizedBox(width: 6),
                recipe.requiresAdult
                    ? const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626))
                    : const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
