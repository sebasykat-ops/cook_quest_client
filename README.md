# CookQuest Client (Flutter)

Flutter client refactored with clean boundaries inspired by backend DDD rules.

## Architecture
- `core`
  - `config`
  - `di`
  - `error`
  - `network`
- `features/recipes`
  - `domain` (entities, repositories)
  - `application` (use cases)
  - `infrastructure` (data sources, repositories, schema, container)
  - `presentation` (controllers, pages, widgets)
- `features/missions`
  - `presentation`

## Rules applied
- Presentation only calls controllers/use cases.
- Controllers do not call HTTP/Dio directly.
- Repository access is encapsulated in use cases.
- Input/response parsing isolated in schema classes.
- Dependency wiring centralized in `AppContainer`.
- Imports use package paths (`package:cook_quest_client/...`) for readability.

## Run
```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

### Platform base URL notes
- Android emulator:
```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

- iOS simulator:
```bash
flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

- Physical device (replace IP):
```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.50:3000
```
