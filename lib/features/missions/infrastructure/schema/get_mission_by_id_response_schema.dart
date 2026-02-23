import 'package:cook_quest_client/core/error/app_exception.dart';

class GetMissionByIdResponseSchema {
  static Map<String, dynamic> parse(dynamic body) {
    if (body is! Map<String, dynamic>) {
      throw AppException('Invalid get mission response format');
    }

    if (body['success'] != true) {
      throw AppException('Backend returned get mission error response');
    }

    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw AppException('Invalid get mission payload');
    }

    if (data['id'] is! String) {
      throw AppException('Invalid get mission payload: id is required');
    }

    if (
      data['currentStep'] is! num ||
      data['totalSteps'] is! num ||
      data['isCompleted'] is! bool ||
      data['completedTimes'] is! num ||
      data['stepCompletions'] is! List ||
      data['missionCode'] is! String
    ) {
      throw AppException(
        'Invalid get mission payload: currentStep/totalSteps/isCompleted/completedTimes/stepCompletions/missionCode are required',
      );
    }

    return data;
  }
}
