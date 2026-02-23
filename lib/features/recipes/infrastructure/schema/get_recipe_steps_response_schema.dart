import 'package:cook_quest_client/core/error/app_exception.dart';

class GetRecipeStepsResponseSchema {
  static List<Map<String, dynamic>> parse(dynamic body) {
    if (body is! Map<String, dynamic>) {
      throw AppException('Invalid recipe steps response format');
    }

    if (body['success'] != true) {
      throw AppException('Backend returned an error for recipe steps');
    }

    final data = body['data'];
    if (data is! List) {
      throw AppException('Invalid recipe steps payload');
    }

    return data.whereType<Map<String, dynamic>>().toList(growable: false);
  }
}
