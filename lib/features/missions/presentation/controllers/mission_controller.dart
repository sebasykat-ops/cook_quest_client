import 'package:flutter/foundation.dart';

import 'package:cook_quest_client/features/missions/application/use_cases/advance_mission_step_use_case.dart';
import 'package:cook_quest_client/features/missions/application/use_cases/get_mission_by_id_use_case.dart';
import 'package:cook_quest_client/features/missions/domain/entities/mission_entity.dart';

class MissionController extends ChangeNotifier {
  MissionController({
    required GetMissionByIdUseCase getMissionByIdUseCase,
    required AdvanceMissionStepUseCase advanceMissionStepUseCase,
  }) : _getMissionByIdUseCase = getMissionByIdUseCase,
       _advanceMissionStepUseCase = advanceMissionStepUseCase;

  final GetMissionByIdUseCase _getMissionByIdUseCase;
  final AdvanceMissionStepUseCase _advanceMissionStepUseCase;

  bool isLoading = false;
  String? errorMessage;
  MissionEntity? mission;

  Future<void> loadMission(String missionId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      mission = await _getMissionByIdUseCase.run(missionId);
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
