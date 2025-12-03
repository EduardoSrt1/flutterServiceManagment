import 'package:atendimentos_app/domain/contract/atendimento_repository.dart';
import 'package:atendimentos_app/domain/usecases/create_atendimentos_usecase.dart';
import 'package:atendimentos_app/domain/usecases/delete_atendimento_usecase.dart';
import 'package:atendimentos_app/domain/usecases/filter_atendimento_usecase.dart';
import 'package:atendimentos_app/domain/usecases/get_atendimentos_usecase.dart';
import 'package:atendimentos_app/domain/usecases/update_atendimentos_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entity/atendimento.dart';
import '../../data/repository/atendimento_repository.dart';
part 'atendimento_state.dart';

@injectable
class AtendimentoCubit extends Cubit<AtendimentoState> {
  final GetAtendimentosUsecase _getAtendimentos;
  final CreateAtendimentoUsecase _createAtendimento;
  final UpdateAtendimentoUsecase _updateAtendimento;
  final DeleteAtendimentoUsecase _deleteAtendimento;
  final FilterAtendimentosUsecase _filterAtendimentos;

  AtendimentoCubit(
    this._getAtendimentos,
    this._createAtendimento,
    this._updateAtendimento,
    this._deleteAtendimento,
    this._filterAtendimentos,
  ) : super(AtendimentoInitial());

  Future<void> loadAtendimentos() async {
    try {
      emit(AtendimentoLoading());
      final atendimentos = await _getAtendimentos();
      emit(AtendimentoLoaded(atendimentos));
    } catch (e) {
      emit(AtendimentoError(e.toString()));
    }
  }

  Future<void> create(Atendimento atendimento) async {
    try {
      emit(AtendimentoLoading());
      await _createAtendimento(atendimento);
      await loadAtendimentos(); // Recarrega a lista
    } catch (e) {
      emit(AtendimentoError(e.toString()));
    }
  }

  Future<void> update(Atendimento atendimento) async {
    try {
      emit(AtendimentoLoading());
      await _updateAtendimento(atendimento);
      await loadAtendimentos(); // Recarrega a lista
    } catch (e) {
      emit(AtendimentoError(e.toString()));
    }
  }

  Future<void> delete(int id) async {
    try {
      emit(AtendimentoLoading());
      await _deleteAtendimento(id);
      await loadAtendimentos(); // Recarrega a lista
    } catch (e) {
      emit(AtendimentoError(e.toString()));
    }
  }

  Future<void> filterByStatus(String status) async {
    try {
      emit(AtendimentoLoading());
      final atendimentos = await _filterAtendimentos(status);
      emit(AtendimentoLoaded(atendimentos));
    } catch (e) {
      emit(AtendimentoError(e.toString()));
    }
  }
}
