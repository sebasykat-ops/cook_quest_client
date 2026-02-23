import 'package:flutter/material.dart';

import '../../domain/entities/recipe_entity.dart';

class RecipeTile extends StatelessWidget {
  const RecipeTile({super.key, required this.recipe, required this.onTap});

  final RecipeEntity recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(recipe.title),
        subtitle: Text('${recipe.difficulty} • ${recipe.totalMinutes} min'),
        trailing: recipe.requiresAdult
            ? const Icon(Icons.warning_amber_rounded, color: Colors.red)
            : const Icon(Icons.check_circle_outline, color: Colors.green),
      ),
    );
  }
}
