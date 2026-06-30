// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dvd_logo_animation/features/dvd_animation/data/repositories/dvd_color_repository_impl.dart'
    as _i763;
import 'package:dvd_logo_animation/features/dvd_animation/domain/repositories/dvd_color_repository.dart'
    as _i1003;
import 'package:dvd_logo_animation/features/dvd_animation/presentation/cubit/dvd_animation_cubit.dart'
    as _i189;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i1003.DvdColorRepository>(
      () => _i763.DvdColorRepositoryImpl(),
    );
    gh.factory<_i189.DvdAnimationCubit>(
      () => _i189.DvdAnimationCubit(gh<_i1003.DvdColorRepository>()),
    );
    return this;
  }
}
