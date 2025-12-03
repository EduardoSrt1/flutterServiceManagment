import 'package:atendimentos_app/domain/contract/atendimento_repository.dart';
import 'package:atendimentos_app/domain/entity/atendimento.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAtendimentosUsecase {
  final AtendimentoRepository _repository;

  GetAtendimentosUsecase(this._repository);

  Future<List<Atendimento>> call() => _repository.getAtendimentos();
}
