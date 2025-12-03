import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../../data/datasource/sqlite_datasource.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  // PASSO 1: Cria e registra o SqliteDataSource MANUALMENTE
  final dataSource = await SqliteDataSource.create();
  getIt.registerSingleton<SqliteDataSource>(dataSource);

  // PASSO 2: Inicializa o resto das dependências
  await getIt.init();
}
