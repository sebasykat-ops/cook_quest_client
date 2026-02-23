import 'package:cook_quest_client/core/error/app_exception.dart';

class PostAdvanceMissionStepResponseSchema {
  static Map<String, dynamic> parse(dynamic body) {
    if (body is! Map<String, dynamic>) {
      throw AppException('Invalid advance mission response format');
    }

    if (body['success'] != true) {
      throw AppException('Backend returned advance mission error response');
    }

    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw AppException('Invalid advance mission payload');
    }

    if (data['missionId'] is! String) {
      throw AppException('Invalid advance mission payload: missionId is required');
    }

    if (
      data['currentStep'] is! num ||
      data['totalSteps'] is! num ||
      data['isCompleted'] is! bool ||
      data['completedTimes'] is! num ||
      data['missionCode'] is! String
    ) {
      throw AppException(
        'Invalid advance mission payload: currentStep/totalSteps/isCompleted/completedTimes/missionCode are required',
      );
    }

    return data;
  }
}
