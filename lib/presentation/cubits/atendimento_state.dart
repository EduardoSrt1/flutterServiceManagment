part of 'atendimento_cubit.dart';

abstract class AtendimentoState {}

class AtendimentoInitial extends AtendimentoState {}

class AtendimentoLoading extends AtendimentoState {}

class AtendimentoLoaded extends AtendimentoState {
  final List<Atendimento> atendimentos;

  AtendimentoLoaded(this.atendimentos);
}

class AtendimentoError extends AtendimentoState {
  final String message;

  AtendimentoError(this.message);
}
