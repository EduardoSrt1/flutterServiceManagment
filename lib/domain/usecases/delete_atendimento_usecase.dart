import 'package:atendimentos_app/domain/contract/atendimento_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAtendimentoUsecase {
  final AtendimentoRepository _repository;

  DeleteAtendimentoUsecase(this._repository);

  Future<void> call(int id) => _repository.delete(id);
}
