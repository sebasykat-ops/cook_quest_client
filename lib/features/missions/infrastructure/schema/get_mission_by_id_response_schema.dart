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

    if (data['currentStep'] is! num || data['isCompleted'] is! bool) {
      throw AppException('Invalid get mission payload: currentStep/isCompleted are required');
    }

    return data;
  }
}
