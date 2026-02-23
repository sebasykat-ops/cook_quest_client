import 'package:cook_quest_client/core/error/app_exception.dart';

class GetMissionResponseSchema {
  static Map<String, dynamic> parse(dynamic body) {
    if (body is! Map<String, dynamic>) {
      throw AppException('Invalid mission response format');
    }

    if (body['success'] != true) {
      throw AppException('Backend returned mission error response');
    }

    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw AppException('Invalid mission payload');
    }

    return data;
  }
}
