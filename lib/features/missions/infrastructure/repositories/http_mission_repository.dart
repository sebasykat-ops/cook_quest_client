import 'package:cook_quest_client/features/missions/domain/entities/mission_entity.dart';
import 'package:cook_quest_client/features/missions/domain/repositories/mission_repository.dart';
import 'package:cook_quest_client/features/missions/infrastructure/data_sources/http_mission_data_source.dart';
import 'package:cook_quest_client/features/missions/infrastructure/models/mission_model.dart';
import 'package:cook_quest_client/features/missions/infrastructure/schema/get_mission_by_id_response_schema.dart';
import 'package:cook_quest_client/features/missions/infrastructure/schema/post_advance_mission_step_response_schema.dart';

class HttpMissionRepository implements MissionRepository {
  HttpMissionRepository({required HttpMissionDataSource missionDataSource})
    : _missionDataSource = missionDataSource;

  final HttpMissionDataSource _missionDataSource;

  @override
  Future<MissionEntity> getMissionById(String missionId) async {
    final rawBody = await _missionDataSource.getMissionById(missionId);
    final data = GetMissionByIdResponseSchema.parse(rawBody);
    return MissionModel.fromGetMissionByIdJson(data);
  }

  @override
  Future<MissionEntity> advanceMissionStep(String missionId) async {
    final rawBody = await _missionDataSource.advanceMissionStep(missionId);
    final data = PostAdvanceMissionStepResponseSchema.parse(rawBody);

    final currentMission = await getMissionById(missionId);

    return MissionModel.fromAdvanceMissionStepJson(
      data,
      fallbackRecipeId: currentMission.recipeId,
    );
  }
}
