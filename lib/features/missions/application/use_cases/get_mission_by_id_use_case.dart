import 'package:cook_quest_client/features/missions/domain/entities/mission_entity.dart';
import 'package:cook_quest_client/features/missions/domain/repositories/mission_repository.dart';

class GetMissionByIdUseCase {
  GetMissionByIdUseCase({required MissionRepository missionRepository})
    : _missionRepository = missionRepository;

  final MissionRepository _missionRepository;

  Future<MissionEntity> run(String missionId) {
    return _missionRepository.getMissionById(missionId);
  }
}
