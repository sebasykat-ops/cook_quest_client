import 'package:flutter/material.dart';

import 'package:cook_quest_client/app.dart';
import 'package:cook_quest_client/core/di/app_container.dart';

void main() {
  final appContainer = AppContainer();
  runApp(App(appContainer: appContainer));
}
