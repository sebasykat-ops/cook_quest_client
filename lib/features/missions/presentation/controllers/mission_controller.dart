import 'package:flutter/foundation.dart';

import 'package:cook_quest_client/features/missions/application/use_cases/advance_mission_step_use_case.dart';
import 'package:cook_quest_client/features/missions/application/use_cases/get_mission_by_id_use_case.dart';
import 'package:cook_quest_client/features/missions/domain/entities/mission_entity.dart';
import 'package:cook_quest_client/features/recipes/application/use_cases/get_recipe_steps_use_case.dart';
import 'package:cook_quest_client/features/recipes/domain/entities/recipe_step_entity.dart';

class MissionController extends ChangeNotifier {
  MissionController({
    required GetMissionByIdUseCase getMissionByIdUseCase,
    required AdvanceMissionStepUseCase advanceMissionStepUseCase,
    required GetRecipeStepsUseCase getRecipeStepsUseCase,
  }) : _getMissionByIdUseCase = getMissionByIdUseCase,
       _advanceMissionStepUseCase = advanceMissionStepUseCase,
       _getRecipeStepsUseCase = getRecipeStepsUseCase;

  final GetMissionByIdUseCase _getMissionByIdUseCase;
  final AdvanceMissionStepUseCase _advanceMissionStepUseCase;
  final GetRecipeStepsUseCase _getRecipeStepsUseCase;

  bool isLoading = false;
  String? errorMessage;
  MissionEntity? mission;
  List<RecipeStepEntity> steps = [];

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

  Future<void> loadMission(String missionId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      mission = await _getMissionByIdUseCase.run(missionId);
      steps = await _getRecipeStepsUseCase.run(mission!.recipeId);
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> advanceStep(String missionId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      mission = await _advanceMissionStepUseCase.run(missionId);
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
