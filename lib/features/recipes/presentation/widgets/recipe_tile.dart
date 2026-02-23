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
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Row(
          children: [
            Expanded(child: Text(recipe.title)),
            if (wasCompletedBefore)
              const Tooltip(
                message: 'Receta completada anteriormente',
                child: Icon(Icons.emoji_events_rounded, color: Colors.amber),
              ),
          ],
        ),
        subtitle: Text('${recipe.difficulty} • ${recipe.totalMinutes} min'),
        trailing: recipe.requiresAdult
            ? const Icon(Icons.warning_amber_rounded, color: Colors.red)
            : const Icon(Icons.check_circle_outline, color: Colors.green),
      ),
    );
  }
}
