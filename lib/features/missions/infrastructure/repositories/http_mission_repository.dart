import 'package:cook_quest_client/features/missions/domain/entities/mission_entity.dart';
import 'package:cook_quest_client/features/missions/domain/repositories/mission_repository.dart';
import 'package:cook_quest_client/features/missions/infrastructure/data_sources/http_mission_data_source.dart';
import 'package:cook_quest_client/features/missions/infrastructure/models/mission_model.dart';
import 'package:cook_quest_client/features/missions/infrastructure/schema/get_mission_response_schema.dart';

class HttpMissionRepository implements MissionRepository {
  HttpMissionRepository({required HttpMissionDataSource missionDataSource})
    : _missionDataSource = missionDataSource;

  final HttpMissionDataSource _missionDataSource;

  @override
  Future<MissionEntity> getMissionById(String missionId) async {
    final rawBody = await _missionDataSource.getMissionById(missionId);
    final data = GetMissionResponseSchema.parse(rawBody);
    return MissionModel.fromJson(data);
  }

  @override
  Future<MissionEntity> advanceMissionStep(String missionId) async {
    final rawBody = await _missionDataSource.advanceMissionStep(missionId);
    final data = GetMissionResponseSchema.parse(rawBody);

    // advance-step endpoint returns reduced payload; normalize for model parsing
    final normalizedData = <String, dynamic>{
      'missionId': data['missionId'],
      'recipeId': data['recipeId'] ?? 'unknown-recipe',
      'currentStep': data['currentStep'],
      'isCompleted': data['isCompleted'],
    };

    return MissionModel.fromJson(normalizedData);
  }
}
