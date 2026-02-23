import 'package:cook_quest_client/features/missions/domain/entities/mission_entity.dart';

abstract class MissionRepository {
  Future<MissionEntity> getMissionById(String missionId);
  Future<MissionEntity> advanceMissionStep(String missionId);
}
