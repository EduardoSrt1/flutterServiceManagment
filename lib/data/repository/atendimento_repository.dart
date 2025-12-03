import 'package:atendimentos_app/domain/contract/atendimento_repository.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/atendimento.dart';
import '../datasource/sqlite_datasource.dart';

@Injectable(as: AtendimentoRepository)
class AtendimentoRepositoryImpl implements AtendimentoRepository {
  final SqliteDataSource datasource;
  AtendimentoRepositoryImpl(this.datasource);

  @override
  Future<void> create(Atendimento a) => datasource.insert(a);

  @override
  Future<void> delete(int id) => datasource.delete(id);

  @override
  Future<List<Atendimento>> filterByStatus(String status) =>
      datasource.filterByStatus(status);

  @override
  Future<List<Atendimento>> getAtendimentos() => datasource.getAll();

  @override
  Future<void> update(Atendimento a) => datasource.update(a);
}
