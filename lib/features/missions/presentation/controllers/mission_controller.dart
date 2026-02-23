import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:cook_quest_client/features/missions/application/use_cases/advance_mission_step_use_case.dart';
import 'package:cook_quest_client/features/missions/application/use_cases/get_mission_by_id_use_case.dart';
import 'package:cook_quest_client/features/missions/application/use_cases/restart_mission_use_case.dart';
import 'package:cook_quest_client/features/missions/domain/entities/mission_entity.dart';
import 'package:cook_quest_client/features/recipes/application/use_cases/get_recipe_steps_use_case.dart';
import 'package:cook_quest_client/features/recipes/domain/entities/recipe_step_entity.dart';

class MissionController extends ChangeNotifier {
  MissionController({
    required GetMissionByIdUseCase getMissionByIdUseCase,
    required AdvanceMissionStepUseCase advanceMissionStepUseCase,
    required RestartMissionUseCase restartMissionUseCase,
    required GetRecipeStepsUseCase getRecipeStepsUseCase,
  }) : _getMissionByIdUseCase = getMissionByIdUseCase,
       _advanceMissionStepUseCase = advanceMissionStepUseCase,
       _restartMissionUseCase = restartMissionUseCase,
       _getRecipeStepsUseCase = getRecipeStepsUseCase;

  final GetMissionByIdUseCase _getMissionByIdUseCase;
  final AdvanceMissionStepUseCase _advanceMissionStepUseCase;
  final RestartMissionUseCase _restartMissionUseCase;
  final GetRecipeStepsUseCase _getRecipeStepsUseCase;

  bool isLoading = false;
  String? errorMessage;
  MissionEntity? mission;
  List<RecipeStepEntity> steps = [];

  Timer? _timer;
  int remainingSeconds = 0;
  bool isTimerRunning = false;

  RecipeStepEntity? get currentStep {
    if (mission == null || steps.isEmpty) {
      return null;
    }

    final index = mission!.currentStep - 1;
    if (index < 0 || index >= steps.length) {
      return null;
    }

    return steps[index];
  }

  String get timerLabel {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> loadMission(String missionId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      mission = await _getMissionByIdUseCase.run(missionId);
      steps = await _getRecipeStepsUseCase.run(mission!.recipeId);
      _loadTimerFromCurrentStep();
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> advanceStep(String missionId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    var becameCompleted = false;

    try {
      mission = await _advanceMissionStepUseCase.run(missionId);
      _stopTimer();
      _loadTimerFromCurrentStep();
      becameCompleted = mission?.isCompleted ?? false;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return becameCompleted;
  }

  Future<void> restartRecipe(String missionId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      mission = await _restartMissionUseCase.run(missionId);
      _stopTimer();
      _loadTimerFromCurrentStep();
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void startTimer() {
    if (remainingSeconds <= 0 || isTimerRunning) {
      return;
    }

    isTimerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds <= 0) {
        _stopTimer();
        notifyListeners();
        return;
      }

      remainingSeconds -= 1;
      notifyListeners();
    });

    notifyListeners();
  }

  void pauseTimer() {
    _stopTimer();
    notifyListeners();
  }

  void addOneMinute() {
    remainingSeconds += 60;
    notifyListeners();
  }

  void resetTimerFromStep() {
    _stopTimer();
    _loadTimerFromCurrentStep();
    notifyListeners();
  }

  void _loadTimerFromCurrentStep() {
    remainingSeconds = currentStep?.timerSeconds ?? 0;
    isTimerRunning = false;
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    isTimerRunning = false;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
