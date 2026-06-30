import 'package:dvd_logo_animation/core/extensions/color_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ColorX', () {
    group('random', () {
      test('should return a color with all channels in the default 0-255 range',
          () {
        for (var i = 0; i < 100; i++) {
          final color = ColorX.random();
          final r = (color.r * 255).round();
          final g = (color.g * 255).round();
          final b = (color.b * 255).round();
          expect(r, inInclusiveRange(0, 255));
          expect(g, inInclusiveRange(0, 255));
          expect(b, inInclusiveRange(0, 255));
        }
      });

      test('should return a color within specified per-channel ranges', () {
        for (var i = 0; i < 100; i++) {
          final color = ColorX.random(
            redMin: 50,
            redMax: 100,
            greenMin: 150,
            greenMax: 200,
            blueMin: 10,
            blueMax: 30,
          );
          final r = (color.r * 255).round();
          final g = (color.g * 255).round();
          final b = (color.b * 255).round();
          expect(r, inInclusiveRange(50, 100));
          expect(g, inInclusiveRange(150, 200));
          expect(b, inInclusiveRange(10, 30));
        }
      });

      test('should return exact color when min equals max for all channels',
          () {
        final color = ColorX.random(
          redMin: 128,
          redMax: 128,
          greenMin: 64,
          greenMax: 64,
          blueMin: 32,
          blueMax: 32,
        );
        final r = (color.value >> 16) & 0xFF;
        final g = (color.value >> 8) & 0xFF;
        final b = color.value & 0xFF;
        expect(r, 128);
        expect(g, 64);
        expect(b, 32);
      });

      test('should throw when a min param is negative', () {
        expect(() => ColorX.random(redMin: -1), throwsAssertionError);
        expect(() => ColorX.random(greenMin: -1), throwsAssertionError);
        expect(() => ColorX.random(blueMin: -1), throwsAssertionError);
      });

      test('should throw when a max param exceeds 255', () {
        expect(() => ColorX.random(redMax: 256), throwsAssertionError);
        expect(() => ColorX.random(greenMax: 256), throwsAssertionError);
        expect(() => ColorX.random(blueMax: 256), throwsAssertionError);
      });

      test('should throw when min exceeds max', () {
        expect(
          () => ColorX.random(redMin: 100, redMax: 50),
          throwsAssertionError,
        );
        expect(
          () => ColorX.random(greenMin: 200, greenMax: 100),
          throwsAssertionError,
        );
        expect(
          () => ColorX.random(blueMin: 50, blueMax: 10),
          throwsAssertionError,
        );
      });
    });
  });
}
