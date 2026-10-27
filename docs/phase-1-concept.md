# Outspot — App Concept and Development Plan

SWAPD 402 Mobile Application Development · Phase 1 deliverable (Week 5)

## App idea

Outspot is a Flutter app for discovering and sharing places worth visiting: quiet cafes, study spots, gardens, rooftops, and other local finds. Each post ("spot") pairs a photo with a pinned map location, a caption, descriptive tags, and a budget level. People find spots through a photo-led feed or an interactive map.

### Problem it solves

Recommendations for good local places are scattered across group chats, stories, and general review apps that favour big businesses and star ratings. Outspot collects small, personal recommendations in one place and attaches them to an exact map pin and a price level, so people can answer "where should we go?" quickly.

### Target users

- University students looking for affordable places to study or meet friends.
- Young adults planning outings who care about atmosphere and budget.
- Local explorers who enjoy documenting and sharing hidden places.

### Key use cases

1. **Browse:** scroll a feed of recent spots, each showing a photo, place name, budget, tags, and like count.
2. **Explore nearby:** open a map with spot markers and tap one to preview the place.
3. **Share a spot:** pin a location, add a photo, caption, tags, and budget, review it, and publish.
4. **React and discuss:** like a spot, read comments, and add a comment.
5. **Keep for later:** save spots to a private Saved Places list.
6. **Own an identity:** sign up with a public username, then view and edit a profile showing your posts and the likes they received.

## Main modules and screens

| Module | Screens |
| --- | --- |
| Authentication | Welcome, Sign in, Create account |
| Feed | Spot feed, Spot detail (likes, saves, comments) |
| Explore | Map with spot markers and preview |
| Create spot | Location picker → Details (photo, caption, tags, budget) → Review |
| Saved | Saved Places list |
| Profile | Profile with stats and posts, Edit profile |

Navigation uses a bottom bar (Feed, Explore, Saved, Profile) with a central Create button. Authentication screens sit outside the main shell.

## Device capabilities

- **GPS / location:** centre the map and pre-fill a new spot's pin.
- **Camera and gallery:** attach a photo to a spot.
- **Network:** load and publish spots through a Supabase backend.

## Development plan and milestones

| Phase | Week | Goal | Milestones (GitHub parent issues) |
| --- | --- | --- | --- |
| 1: Concept and basic UI | 5 | Working app shell and every main screen on mock data | P1-01 Repository bootstrap and team workflow · P1-02 App structure and integration contracts · P1-03 App shell, theme, and navigation · P1-04 Feed, spot detail, and explore map UI · P1-05 Create-a-spot flow UI · P1-06 Authentication, profile, and saved-place UI · P1-07 Phase 1 integration and UI sign-off |
| 2: Core functionality and data | 8 | Real accounts and live data with Provider state management | P2-01 Supabase project, schema, storage, and access policies · P2-02 Authentication and profile lifecycle · P2-03 Data models, repositories, and Provider wiring · P2-04 Publish a spot with location and photo (GPS + camera) · P2-05 Live feed, detail, and map · P2-06 Likes, saves, comments, and profile management · P2-07 Search and tag/budget filters · P2-08 Integration and core-flow verification |
| 3: Finalization and deployment | 12 | Polished, tested, release-ready app | P3-01 Security and data-integrity audit · P3-02 Automated tests and regression pass · P3-03 UX polish, accessibility, and permission recovery · P3-04 Performance and runtime reliability · P3-05 Platform validation and release builds (icon, splash, APK) · P3-06 Final documentation, demo, and submission |

### How features evolve

- **Phase 1:** every screen exists and navigates correctly, using shared models (`Spot`, `Profile`, `Comment`) and a mock `SpotRepository`. Forms validate input; map, photo, and publish steps are local previews.
- **Phase 2:** a Supabase-backed repository replaces the mock behind the same contract, so screens keep working unchanged. Auth, publishing with real GPS and camera input, likes, saves, comments, and filters become live.
- **Phase 3:** the team hardens security policies, expands tests, polishes animations and accessibility, adds the app icon and splash screen, and ships a release APK for the Week 15 demo.

## Technology

Flutter and Dart · Provider for state management · flutter_map with OpenStreetMap tiles · Supabase (auth, Postgres, storage) from Phase 2 · GitHub Actions running format, analyze, and test on every PR.
