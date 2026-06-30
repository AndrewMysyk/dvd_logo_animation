# DVD Logo Animation

A Flutter recreation of the classic DVD logo screensaver — the logo bounces around the screen and changes color each time it hits an edge.

## Features

- Smooth 60fps bounce animation driven by a periodic ticker
- Color changes on every wall collision
- Logo dimensions sourced from a single config class, shared between the UI and physics
- Accurate SVG viewBox cropped to artwork bounds — no letterboxing
- Responds to screen size changes (e.g. rotation)

## Architecture

The project follows Flutter Clean Architecture with a feature-first folder structure.

```text
lib/
├── app.dart
├── core/
│   └── di/                        # Dependency injection (get_it + injectable)
└── features/
    └── dvd_animation/
        ├── data/
        │   └── repositories/      # DvdColorRepositoryImpl
        ├── domain/
        │   ├── entities/          # DvdLogoEntity, DvdLogoConfig
        │   └── repositories/      # DvdColorRepository (abstract)
        └── presentation/
            ├── cubit/             # DvdAnimationCubit, DvdAnimationState
            ├── view/              # DvdAnimationPage
            └── widgets/           # DvdLogoWidget
```

### Key decisions

- **Cubit over Bloc** — there is only one external trigger (`start`) and one internal tick; events would add no value here
- **`DvdLogoConfig`** — single source of truth for logo dimensions, used by both the widget (rendering) and the cubit (physics), so the bounding box always matches what is displayed
- **`LayoutBuilder` for screen size** — measures the actual drawable area of the Scaffold body rather than relying on `MediaQuery`, ensuring correct bounce boundaries on all devices

## Getting started

```bash
flutter pub get
dart run build_runner build
flutter run
```

## Dependencies

| Package | Purpose |
| --- | --- |
| `flutter_bloc` | Cubit state management |
| `equatable` | Value equality for state |
| `flutter_svg` | SVG rendering |
| `get_it` + `injectable` | Service locator / DI |
| `flutter_gen` | Type-safe asset references |
