// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../data/datasource/sqlite_datasource.dart' as _i883;
import '../data/repository/atendimento_repository.dart' as _i579;
import '../domain/contract/atendimento_repository.dart' as _i940;
import '../domain/usecases/create_atendimentos_usecase.dart' as _i576;
import '../domain/usecases/delete_atendimento_usecase.dart' as _i1014;
import '../domain/usecases/filter_atendimento_usecase.dart' as _i395;
import '../domain/usecases/get_atendimentos_usecase.dart' as _i560;
import '../domain/usecases/update_atendimentos_usecase.dart' as _i987;
import '../presentation/cubits/atendimento_cubit.dart' as _i827;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i940.AtendimentoRepository>(
        () => _i579.AtendimentoRepositoryImpl(gh<_i883.SqliteDataSource>()));
    gh.factory<_i576.CreateAtendimentoUsecase>(() =>
        _i576.CreateAtendimentoUsecase(gh<_i940.AtendimentoRepository>()));
    gh.factory<_i1014.DeleteAtendimentoUsecase>(() =>
        _i1014.DeleteAtendimentoUsecase(gh<_i940.AtendimentoRepository>()));
    gh.factory<_i395.FilterAtendimentosUsecase>(() =>
        _i395.FilterAtendimentosUsecase(gh<_i940.AtendimentoRepository>()));
    gh.factory<_i560.GetAtendimentosUsecase>(
        () => _i560.GetAtendimentosUsecase(gh<_i940.AtendimentoRepository>()));
    gh.factory<_i987.UpdateAtendimentoUsecase>(() =>
        _i987.UpdateAtendimentoUsecase(gh<_i940.AtendimentoRepository>()));
    gh.factory<_i827.AtendimentoCubit>(() => _i827.AtendimentoCubit(
          gh<_i560.GetAtendimentosUsecase>(),
          gh<_i576.CreateAtendimentoUsecase>(),
          gh<_i987.UpdateAtendimentoUsecase>(),
          gh<_i1014.DeleteAtendimentoUsecase>(),
          gh<_i395.FilterAtendimentosUsecase>(),
        ));
    return this;
  }
}
