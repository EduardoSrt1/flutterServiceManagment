import 'package:atendimentos_app/domain/contract/atendimento_repository.dart';
import 'package:atendimentos_app/domain/entity/atendimento.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateAtendimentoUsecase {
  final AtendimentoRepository _repository;

  CreateAtendimentoUsecase(this._repository);

  Future<void> call(Atendimento atendimento) => _repository.create(atendimento);
}
