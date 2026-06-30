import 'dart:math';
import 'dart:ui';

extension ColorX on Color {
  static Color random({
    int redMin = 0,
    int redMax = 255,
    int greenMin = 0,
    int greenMax = 255,
    int blueMin = 0,
    int blueMax = 255,
  }) {
    assert(redMin >= 0 && redMin <= 255, 'redMin must be between 0 and 255');
    assert(redMax >= 0 && redMax <= 255, 'redMax must be between 0 and 255');
    assert(redMin <= redMax, 'redMin must not exceed redMax');
    assert(
      greenMin >= 0 && greenMin <= 255,
      'greenMin must be between 0 and 255',
    );
    assert(
      greenMax >= 0 && greenMax <= 255,
      'greenMax must be between 0 and 255',
    );
    assert(greenMin <= greenMax, 'greenMin must not exceed greenMax');
    assert(
      blueMin >= 0 && blueMin <= 255,
      'blueMin must be between 0 and 255',
    );
    assert(
      blueMax >= 0 && blueMax <= 255,
      'blueMax must be between 0 and 255',
    );
    assert(blueMin <= blueMax, 'blueMin must not exceed blueMax');
    final rng = Random();
    return Color.fromARGB(
      255,
      redMin + rng.nextInt(redMax - redMin + 1),
      greenMin + rng.nextInt(greenMax - greenMin + 1),
      blueMin + rng.nextInt(blueMax - blueMin + 1),
    );
  }
}
