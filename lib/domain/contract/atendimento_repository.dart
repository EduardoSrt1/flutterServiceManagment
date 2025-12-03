import 'package:atendimentos_app/domain/entity/atendimento.dart';

abstract class AtendimentoRepository {
  Future<List<Atendimento>> getAtendimentos();
  Future<void> update(Atendimento a);
  Future<void> delete(int id);
  Future<void> create(Atendimento a);
  Future<List<Atendimento>> filterByStatus(String status);
}
