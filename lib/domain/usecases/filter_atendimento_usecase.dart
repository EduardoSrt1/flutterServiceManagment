import 'package:atendimentos_app/domain/contract/atendimento_repository.dart';
import 'package:atendimentos_app/domain/entity/atendimento.dart';
import 'package:injectable/injectable.dart';

@injectable
class FilterAtendimentosUsecase {
  final AtendimentoRepository _repository;

  FilterAtendimentosUsecase(this._repository);

  Future<List<Atendimento>> call(String status) =>
      _repository.filterByStatus(status);
}
