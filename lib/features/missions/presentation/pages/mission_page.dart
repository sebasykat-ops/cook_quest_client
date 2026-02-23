import 'package:flutter/material.dart';

import 'package:cook_quest_client/features/missions/presentation/controllers/mission_controller.dart';

class MissionPage extends StatefulWidget {
  const MissionPage({
    super.key,
    required this.recipeTitle,
    required this.missionId,
    required this.missionController,
    required this.onRecipeCompleted,
  });

  final String recipeTitle;
  final String missionId;
  final MissionController missionController;
  final Future<void> Function() onRecipeCompleted;

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
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
      body: Padding(
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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Código Misión: ${mission.missionCode}'),
                const SizedBox(height: 6),
                Text('Paso ${mission.currentStep} de ${mission.totalSteps}'),
                const SizedBox(height: 12),
                if (step != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Paso ${step.order}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(step.instruction),
                          if (step.tip != null && step.tip!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text('Tip: ${step.tip!}'),
                          ],
                          if (step.requiresAdult) ...[
                            const SizedBox(height: 8),
                            const Text('⚠️ Paso con adulto', style: TextStyle(color: Colors.red)),
                          ],
                        ],
                      ),
                    ),
                  )
                else
                  const Text('No hay contenido para este paso.'),
                const SizedBox(height: 12),
                if (step?.timerSeconds != null && step!.timerSeconds! > 0) ...[
                  Text('Timer: ${missionController.timerLabel}'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.tonal(
                        onPressed: missionController.isTimerRunning
                            ? missionController.pauseTimer
                            : missionController.startTimer,
                        child: Text(missionController.isTimerRunning ? 'Pausar' : 'Iniciar Timer'),
                      ),
                      FilledButton.tonal(
                        onPressed: missionController.addOneMinute,
                        child: const Text('+1 min'),
                      ),
                      FilledButton.tonal(
                        onPressed: missionController.resetTimerFromStep,
                        child: const Text('Reiniciar Timer'),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
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
                      child: Text(mission.isCompleted ? 'Misión Completada' : 'Completar Paso'),
                    ),
                    OutlinedButton(
                      onPressed: missionController.isLoading
                          ? null
                          : () => missionController.restartRecipe(widget.missionId),
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
    );
  }
}
