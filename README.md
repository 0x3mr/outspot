# Outspot

Outspot is a Flutter mobile application for discovering and sharing places.

## Requirements

- Flutter SDK
- Android Studio
- Android SDK and an Android emulator or compatible Android device

## Supported Platforms

- Android

## Android Package Identifier

See the `applicationId` in `android/app/build.gradle` or `android/app/build.gradle.kts`.

## Setup

From the repository root:

```bash
flutter pub get
```

## Run

Start an Android emulator or connect an Android device:

```bash
flutter run
```

To target a specific connected device:

```bash
flutter devices
flutter run -d <device-id>
```

## Project Structure

- `lib/main.dart` — application entry point and shared dependency setup.
- `lib/core/navigation/app_routes.dart` — central route-name registry.
- `lib/core/theme/` — shared theme resources.
- `lib/core/widgets/` — reusable app-wide UI components.
- `lib/models/` — shared `Spot`, `Profile`, and `Comment` models.
- `lib/data/repositories/` — repository contract, mock implementation, and shared spot provider.
- `lib/data/fixtures/` — local sample data used during development and testing.
- `lib/features/auth/` — authentication feature.
- `lib/features/feed/` — feed feature and spot-card/list widgets.
- `lib/features/explore/` — explore feature and map-marker preview widget.
- `lib/features/create_spot/` — create-spot feature.
- `lib/features/profile/` — profile feature.
- `lib/features/spot_detail/` — spot-detail feature and detail widget.
- `test/` — automated widget and application tests.

Feature folders may be expanded as their implementations are developed. Placeholder screens are scaffolding, not finished feature functionality.

## Architecture and Integration Rules

- Register application route names in `lib/core/navigation/app_routes.dart`.
- Keep app-wide dependency setup in `lib/main.dart`; keep feature-specific UI and behavior inside the relevant feature folder.
- Use the shared models in `lib/models/`. Do not define competing feature-specific versions of `Spot`, `Profile`, or `Comment`.
- Features should access spot data through `SpotRepository` and its shared provider rather than implementing their own data access.
- `MockSpotRepository` and local fixtures support development. A future Supabase-backed implementation should implement the same repository contract so UI widgets do not depend on the storage implementation.
- Announce planned changes to `pubspec.yaml`, app startup, global routes, shared models, or shared theme in the team channel before editing those shared files.
- Keep pull requests focused, identify the related issue, describe shared files changed, and include test evidence.
- Feature owners and handoff assignments: **TBD**.

## Quality Checks

Run before opening a pull request:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```
