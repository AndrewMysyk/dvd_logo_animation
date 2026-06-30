# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-06-30

### Added

- DVD logo bounce animation with 60fps periodic ticker
- Color change on every wall collision via `DvdColorRepository`
- `DvdLogoConfig` as a single source of truth for logo dimensions, shared between rendering and physics
- `DvdAnimationCoordinator` in the domain layer — owns all animation physics (position update, wall bounce detection, color index cycling), keeping the cubit free of business logic
- `DvdAnimationCubit` with `start(screenSize, logoSize)` — screen size measured from `LayoutBuilder` to match the actual drawable area
- Minimum window size of 300×300 enforced on Windows (`WM_GETMINMAXINFO`, DPI-aware), macOS (`NSWindow.minSize`), Linux (`gtk_widget_set_size_request`), and web (CSS `min-width`/`min-height`)
- Clean Architecture structure: domain entities, repository abstraction, coordinator, cubit presentation layer
- Dependency injection with `get_it` and `injectable`
- Type-safe asset references via `flutter_gen`
- SVG viewBox cropped to artwork bounds, removing built-in whitespace padding
- Comprehensive test suite covering repository, entity, state, cubit, coordinator, and widget layers

### Changed

- App display name set to "DVD Logo" on mobile and "DVD Logo Animation" on desktop/web
- `injection.config.dart` excluded from version control — it is a `build_runner` output and must be regenerated locally
