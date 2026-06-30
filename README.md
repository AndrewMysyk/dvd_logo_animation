# DVD Logo Animation

A Flutter recreation of the classic DVD logo screensaver — the logo bounces around the screen and changes color each time it hits an edge.

## Features

- Smooth 60fps bounce animation driven by a periodic ticker
- Color changes on every wall collision
- Responds to screen size changes (rotation, window resize)
- Minimum window size of 300×300 enforced on Windows, macOS, Linux, and web

## Architecture

The project follows Flutter Clean Architecture with a feature-first folder structure. Reusable animation infrastructure lives in `core/`; everything DVD-specific lives in `features/dvd_animation/`.

### Key decisions

- **Generic animation core** — `BouncingCoordinator<T>`, `BouncingAnimationController<T>`, and `BouncingZoneWidget<T>` are fully decoupled from the DVD feature; any bouncing animation can reuse them by implementing the coordinator interface
- **`BouncingAnimationController` over cubit** — animation state changes every 16ms; `ChangeNotifier` + `ListenableBuilder` is lighter than a state machine for this use case, and the injectable `TickerFactory` keeps it deterministically testable
- **`DvdAnimationCoordinator`** — owns all physics (position update, bounce detection, color change on collision) so the controller stays free of feature logic and the physics can be tested in isolation
- **`didChangeDependencies` for screen size** — fires on both initial mount and subsequent `MediaQuery` changes (resize, rotation), replacing the previous `LayoutBuilder` + `addPostFrameCallback` pattern
- **`ColorX.random()`** — static extension on `Color` with optional per-channel bounds; keeps color generation as a pure function with no repository indirection
- **`DvdAnimationCubit`** — retained as a placeholder for upcoming playback controls (`togglePlay`, `playbackSpeedChanged`); currently holds `isPlaying` and `playbackSpeed` state but is not yet wired to the UI

## Getting started

```bash
flutter pub get
dart run build_runner build
flutter run
```

> `injection.config.dart` and `assets.gen.dart` are `build_runner` outputs and are not tracked in git. Running the command above regenerates them.

## Dependencies

| Package | Purpose |
| --- | --- |
| `flutter_bloc` | Cubit state management |
| `equatable` | Value equality for state |
| `flutter_svg` | SVG rendering |
| `get_it` + `injectable` | Service locator / DI |
| `flutter_gen` | Type-safe asset references |
