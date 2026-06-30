import 'package:dvd_logo_animation/core/di/injection.dart';

// ignore: one_member_abstracts
abstract class ServiceLocator {
  T get<T extends Object>();
}

class _GetItServiceLocator implements ServiceLocator {
  const _GetItServiceLocator();

  @override
  T get<T extends Object>() => getIt<T>();
}

const ServiceLocator locator = _GetItServiceLocator();
