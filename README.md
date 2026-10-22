# Outspot

Outspot is a Flutter mobile application.

## Prerequisites

Install the following before starting:

- Git
- Flutter SDK (stable channel)
- Android Studio
- Android SDK and an Android emulator or compatible Android device

Verify your setup:

```bash
flutter doctor
```

## Android Configuration

- **Supported target:** Android
- **Application ID:** `com.example.outspot`

## Getting Started

Clone the repository and enter its directory:

```bash
git clone https://github.com/0x3mr/outspot.git
cd outspot
```

Install dependencies:

```bash
flutter pub get
```

Start an Android emulator or connect an Android device. Verify Flutter detects it:

```bash
flutter devices
```

Run the app:

```bash
flutter run
```

## Quality Checks

Run these commands from the repository root before opening a pull request:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

GitHub Actions runs these checks on pushes to `main` and pull requests targeting `main`. A pull request should have passing checks before it is merged.

## Branching Convention

Create a separate branch for each task. Use the task type, issue identifier, and a short description.

Examples:

- `feat/P1-04-feed-ui`
- `fix/P1-04-feed-loading`
- `docs/P1-01-setup-guide`
- `test/P1-01-ci-checks`

Start branches from an up-to-date `main`:

```bash
git switch main
git pull
git switch -c feat/P1-04-feed-ui
```

Keep pull requests focused on one issue and link the relevant GitHub issue in the PR description.

## Pull Requests

When opening a pull request:

- Link the GitHub issue being addressed.
- Summarize the changes.
- Report formatting, analyzer, and test results.
- Include screenshots for UI changes.
- Resolve review feedback and ensure CI passes before merging.

Use the repository pull request template to guide submissions.

## Secrets and Supabase Configuration

Client-side Supabase configuration is not the same as a server secret.

- A Supabase **publishable key** or legacy **anon key** is intended for client applications. Access must still be controlled with appropriate Row Level Security (RLS) policies.
- A Supabase **service-role key** is privileged and must never be included in the Flutter app, shipped to users, or committed to Git.
- Never commit passwords, access tokens, private signing keys, or other service credentials.
- Keep local environment and secret configuration files out of version control. If a secret is accidentally committed, revoke or rotate it; deleting it in a later commit does not make the exposed secret safe.
- Store deployment or server-side secrets in an appropriate secure environment, not in client-side Flutter code.

Review `.gitignore` before adding local configuration files