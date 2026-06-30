# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-06-30

### Added

- DVD logo bounce animation with 60fps periodic ticker
- Color changes on every wall collision
- `ColorX.random()` — static extension on `Color` that generates a random color with optional per-channel min/max bounds (0–255)
- `BouncingCoordinator<T>` — abstract interface in `core/` defining `objectSize`, `initial`, and `tick`; makes the animation system reusable for any bouncing object
- `BouncingAnimationController<T>` — generic `ChangeNotifier`-based controller that drives the animation loop via an injectable `TickerFactory`, decoupling the tick source from the widget tree
- `BouncingZoneWidget<T>` — generic `StatefulWidget` in `core/` that owns the controller lifecycle and calls a `builder` with the current animation state on every tick
- `DvdAnimationCoordinator` — owns all animation physics (position update, bounce detection, color change on collision), implements `BouncingCoordinator<DvdLogoState>`
- `DvdAnimationCubit` with `togglePlay` and `playbackSpeedChanged` placeholder methods for future playback controls, holding `isPlaying` and `playbackSpeed` state
- `DvdLogoConfig` as a single source of truth for logo dimensions
- Minimum window size of 300×300 enforced on Windows (`WM_GETMINMAXINFO`, DPI-aware), macOS (`NSWindow.minSize`), Linux (`gtk_widget_set_size_request`), and web (CSS `min-width`/`min-height`)
- Dependency injection with `get_it` and `injectable`
- Type-safe asset references via `flutter_gen`
- SVG viewBox cropped to artwork bounds, removing built-in whitespace padding
- Comprehensive test suite covering coordinator, controller, cubit, state, widget, and extension layers

### Changed

- App display name set to "DVD Logo" on mobile and "DVD Logo Animation" on desktop/web
- `injection.config.dart` excluded from version control — it is a `build_runner` output and must be regenerated locally
