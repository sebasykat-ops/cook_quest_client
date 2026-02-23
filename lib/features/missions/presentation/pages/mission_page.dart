import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cook_quest_client/features/missions/presentation/controllers/mission_controller.dart';

class MissionPage extends StatefulWidget {
  const MissionPage({
    super.key,
    required this.recipeTitle,
    required this.missionId,
    required this.missionController,
    required this.onRecipeCompleted,
    required this.ingredients,
    required this.utensils,
  });

  final String recipeTitle;
  final String missionId;
  final MissionController missionController;
  final Future<void> Function() onRecipeCompleted;
  final List<String> ingredients;
  final List<String> utensils;

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  bool hasStartedMission = false;
  late List<bool> ingredientChecks;
  late List<bool> utensilChecks;
  bool checklistLoaded = false;

  String get _ingredientPrefsKey => 'checklist.ingredients.${widget.missionId}';
  String get _utensilPrefsKey => 'checklist.utensils.${widget.missionId}';

  bool get _canStartMission {
    final allIngredientsChecked = ingredientChecks.isEmpty || ingredientChecks.every((item) => item);
    final allUtensilsChecked = utensilChecks.isEmpty || utensilChecks.every((item) => item);
    return allIngredientsChecked && allUtensilsChecked;
  }

  @override
  void initState() {
    super.initState();
    ingredientChecks = List<bool>.filled(widget.ingredients.length, false);
    utensilChecks = List<bool>.filled(widget.utensils.length, false);
    widget.missionController.addListener(_onStateChanged);
    widget.missionController.loadMission(widget.missionId);
    _loadChecklistState();
  }

  @override
  void dispose() {
    widget.missionController.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadChecklistState() async {
    final preferences = await SharedPreferences.getInstance();
    final ingredientValues = preferences.getStringList(_ingredientPrefsKey);
    final utensilValues = preferences.getStringList(_utensilPrefsKey);

    if (ingredientValues != null && ingredientValues.length == ingredientChecks.length) {
      ingredientChecks = ingredientValues.map((item) => item == '1').toList(growable: false);
    }

    if (utensilValues != null && utensilValues.length == utensilChecks.length) {
      utensilChecks = utensilValues.map((item) => item == '1').toList(growable: false);
    }

    checklistLoaded = true;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _persistChecklistState() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _ingredientPrefsKey,
      ingredientChecks.map((item) => item ? '1' : '0').toList(growable: false),
    );
    await preferences.setStringList(
      _utensilPrefsKey,
      utensilChecks.map((item) => item ? '1' : '0').toList(growable: false),
    );
  }

  Future<void> _resetChecklistState() async {
    ingredientChecks = List<bool>.filled(widget.ingredients.length, false);
    utensilChecks = List<bool>.filled(widget.utensils.length, false);
    await _persistChecklistState();
  }

  Future<void> _completeStep() async {
    final becameCompleted = await widget.missionController.advanceStep(widget.missionId);

    if (becameCompleted) {
      await widget.onRecipeCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final missionController = widget.missionController;
    final mission = missionController.mission;
    final step = missionController.currentStep;

    return Scaffold(
      appBar: AppBar(title: Text('Misión: ${widget.recipeTitle}')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F5FF), Color(0xFFF3E8FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Builder(
            builder: (context) {
              if (missionController.isLoading && mission == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (missionController.errorMessage != null && mission == null) {
                return Center(child: Text('Error: ${missionController.errorMessage}'));
              }

              if (mission == null) {
                return const Center(child: Text('No mission data'));
              }

              if (!hasStartedMission) {
                if (!checklistLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFF4C1D95),
                      ),
                      child: const Text(
                        'Antes de empezar 🧑‍🍳',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildChecklistCard('Ingredientes', widget.ingredients, ingredientChecks, Icons.shopping_basket_rounded),
                    const SizedBox(height: 12),
                    _buildChecklistCard('Utensilios', widget.utensils, utensilChecks, Icons.kitchen_rounded),
                    const SizedBox(height: 10),
                    Text(
                      _canStartMission
                          ? '✅ Todo listo, puedes comenzar la misión.'
                          : 'Marca todos los elementos para empezar.',
                      style: TextStyle(
                        color: _canStartMission ? const Color(0xFF047857) : const Color(0xFF7C2D12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    FilledButton(
                      onPressed: _canStartMission ? () => setState(() => hasStartedMission = true) : null,
                      child: const Text('Empezar misión'),
                    ),
                  ],
                );
              }

              return ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFF4C1D95),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Código Misión: ${mission.missionCode}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Paso ${mission.currentStep} de ${mission.totalSteps}',
                          style: const TextStyle(color: Color(0xFFE9D5FF)),
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: mission.totalSteps > 0 ? mission.currentStep / mission.totalSteps : 0,
                          borderRadius: BorderRadius.circular(99),
                          backgroundColor: const Color(0xFF6D28D9),
                          color: const Color(0xFF2DD4BF),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (step != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                        boxShadow: const [BoxShadow(color: Color(0x15000000), blurRadius: 12, offset: Offset(0, 5))],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('🧩 Paso ${step.order}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
                          const SizedBox(height: 10),
                          Text(step.instruction, style: const TextStyle(fontSize: 16)),
                          if (step.tip != null && step.tip!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text('💡 Tip: ${step.tip!}'),
                          ],
                          if (step.requiresAdult) ...[
                            const SizedBox(height: 10),
                            const Text('⚠️ Paso con adulto', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold)),
                          ],
                        ],
                      ),
                    )
                  else
                    const Text('No hay contenido para este paso.'),
                  const SizedBox(height: 14),
                  if (step?.timerSeconds != null && step!.timerSeconds! > 0)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: const Color(0xFFEDE9FE)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('⏱️ Timer: ${missionController.timerLabel}', style: const TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              FilledButton.tonal(
                                onPressed: missionController.isTimerRunning ? missionController.pauseTimer : missionController.startTimer,
                                child: Text(missionController.isTimerRunning ? 'Pausar' : 'Iniciar'),
                              ),
                              FilledButton.tonal(onPressed: missionController.addOneMinute, child: const Text('+1 min')),
                              FilledButton.tonal(onPressed: missionController.resetTimerFromStep, child: const Text('Reset')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 14),
                  if (missionController.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('Error: ${missionController.errorMessage}'),
                    ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton(
                        onPressed: missionController.isLoading || mission.isCompleted ? null : _completeStep,
                        child: Text(mission.isCompleted ? 'Misión Completada 🎉' : 'Completar Paso'),
                      ),
                      OutlinedButton(
                        onPressed: missionController.isLoading
                            ? null
                            : () async {
                                await missionController.restartRecipe(widget.missionId);
                                await _resetChecklistState();
                                if (mounted) {
                                  setState(() {
                                    hasStartedMission = false;
                                  });
                                }
                              },
                        child: const Text('Volver a hacer receta'),
                      ),
                    ],
                  ),
                  if (mission.completedTimes > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text('🏆 Completada ${mission.completedTimes} vez/veces'),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistCard(String title, List<String> items, List<bool> checks, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF6D28D9)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return CheckboxListTile(
              value: checks[index],
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFF7C3AED),
              onChanged: (value) async {
                setState(() {
                  checks[index] = value ?? false;
                });
                await _persistChecklistState();
              },
              title: Text(item),
            );
          }),
        ],
      ),
    );
  }
}
