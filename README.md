# CookQuest Client (Flutter)

Flutter client scaffold aligned with DDD/clean boundaries.

## Architecture
- `core` for cross-cutting infra
- `features/recipes`
  - domain
  - data
  - presentation
- `features/missions`
  - presentation (initial)

## Run
```bash
flutter pub get
flutter run
```

## Backend URL
Current base URL in `recipes_page.dart`:
- `http://localhost:3000`

If running on Android emulator, change to:
- `http://10.0.2.2:3000`

If running on physical device, use your machine LAN IP.
