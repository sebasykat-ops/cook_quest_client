import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    widget.missionController.addListener(_onStateChanged);
    widget.missionController.loadMission(widget.missionId);
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
                    _buildChecklistCard('Ingredientes', widget.ingredients, Icons.shopping_basket_rounded),
                    const SizedBox(height: 12),
                    _buildChecklistCard('Utensilios', widget.utensils, Icons.kitchen_rounded),
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: () => setState(() => hasStartedMission = true),
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
                        boxShadow: const [
                          BoxShadow(color: Color(0x15000000), blurRadius: 12, offset: Offset(0, 5)),
                        ],
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
                        onPressed: missionController.isLoading ? null : () => missionController.restartRecipe(widget.missionId),
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

  Widget _buildChecklistCard(String title, List<String> items, IconData icon) {
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
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF10B981)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
