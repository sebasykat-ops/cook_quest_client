import 'package:cook_quest_client/core/network/api_client.dart';

class HttpMissionDataSource {
  HttpMissionDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<dynamic> getMissionById(String missionId) async {
    final response = await _apiClient.dio.get('/missions/$missionId');
    return response.data;
  }

  Future<dynamic> advanceMissionStep(String missionId) async {
    final response = await _apiClient.dio.post('/missions/$missionId/advance-step');
    return response.data;
  }
}
