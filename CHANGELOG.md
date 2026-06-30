# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-06-30

### Added

- DVD logo bounce animation with 60fps periodic ticker
- Color change on every wall collision via `DvdColorRepository`
- `DvdLogoConfig` as a single source of truth for logo dimensions, shared between rendering and physics
- `DvdAnimationCubit` with `start(screenSize, logoSize)` — screen size measured from `LayoutBuilder` to match the actual drawable area
- Clean Architecture structure: domain entities, repository abstraction, cubit presentation layer
- Dependency injection with `get_it` and `injectable`
- Type-safe asset references via `flutter_gen`
- SVG viewBox cropped to artwork bounds, removing built-in whitespace padding
