import 'package:cook_quest_client/core/error/app_exception.dart';

class GetRecipesResponseSchema {
  static List<Map<String, dynamic>> parse(dynamic body) {
    if (body is! Map<String, dynamic>) {
      throw AppException('Invalid response format');
    }

    final success = body['success'];
    if (success != true) {
      throw AppException('Backend returned an error response');
    }

    final data = body['data'];
    if (data is! List) {
      throw AppException('Invalid recipes payload');
    }

    return data.whereType<Map<String, dynamic>>().toList(growable: false);
  }
}
