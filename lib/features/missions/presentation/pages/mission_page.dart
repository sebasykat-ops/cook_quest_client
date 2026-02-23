import 'package:flutter/material.dart';

import 'package:cook_quest_client/features/missions/presentation/controllers/mission_controller.dart';

class MissionPage extends StatefulWidget {
  const MissionPage({
    super.key,
    required this.recipeTitle,
    required this.missionId,
    required this.missionController,
  });

  final String recipeTitle;
  final String missionId;
  final MissionController missionController;

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

  @override
  Widget build(BuildContext context) {
    final missionController = widget.missionController;
    final mission = missionController.mission;

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
                Text('Mission ID: ${mission.id}'),
                const SizedBox(height: 8),
                Text('Current Step: ${mission.currentStep}'),
                const SizedBox(height: 8),
                Text('Completed: ${mission.isCompleted ? 'Yes' : 'No'}'),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: missionController.isLoading || mission.isCompleted
                      ? null
                      : () => missionController.advanceStep(widget.missionId),
                  child: Text(mission.isCompleted ? 'Mission Completed' : 'Advance Step'),
                ),
                if (missionController.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text('Error: ${missionController.errorMessage}'),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
