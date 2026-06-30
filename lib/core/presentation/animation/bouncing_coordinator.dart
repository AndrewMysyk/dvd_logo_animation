import 'dart:ui';

abstract interface class BouncingCoordinator<T> {
  Size get objectSize;
  T initial({required Size screenSize});
  T tick({required T current, required Size screenSize});
}
