// lib/presentation/pages/atendimento_list_page.dart
import 'package:atendimentos_app/presentation/pages/create_page.dart';
import 'package:atendimentos_app/presentation/pages/details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/atendimento_cubit.dart';
import '../../domain/entity/atendimento.dart';

class AtendimentoListPage extends StatefulWidget {
  const AtendimentoListPage({super.key});

  @override
  State<AtendimentoListPage> createState() => _AtendimentoListPageState();
}

class _AtendimentoListPageState extends State<AtendimentoListPage> {
  @override
  void initState() {
    super.initState();
    context.read<AtendimentoCubit>().loadAtendimentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atendimentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<AtendimentoCubit>().loadAtendimentos(),
            tooltip: 'Atualizar',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/create');
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<AtendimentoCubit, AtendimentoState>(
        listener: (context, state) {
          if (state is AtendimentoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Tentar novamente',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<AtendimentoCubit>().loadAtendimentos();
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AtendimentoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AtendimentoLoaded) {
            final atendimentos = state.atendimentos;

            if (atendimentos.isEmpty) {
              return Column(
                children: [
                  _buildFilters(),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Nenhum atendimento encontrado.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () => context
                                .read<AtendimentoCubit>()
                                .loadAtendimentos(),
                            icon: const Icon(Icons.refresh),
                            label: const Text("Limpar filtros"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _buildFilters(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        context.read<AtendimentoCubit>().loadAtendimentos(),
                    child: ListView.builder(
                      itemCount: atendimentos.length,
                      padding: const EdgeInsets.only(bottom: 80),
                      itemBuilder: (context, index) {
                        final atendimento = atendimentos[index];
                        return _buildAtendimentoCard(context, atendimento);
                      },
                    ),
                  ),
                ),
              ],
            );
          }

          // Estado inicial
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Carregue os atendimentos'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<AtendimentoCubit>().loadAtendimentos(),
                  child: const Text('Carregar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAtendimentoCard(BuildContext context, Atendimento atendimento) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          atendimento.titulo ?? 'Sem título',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getStatusIcon(atendimento.status ?? 'ativo'),
                    size: 16,
                    color: _getStatusColor(atendimento.status ?? 'ativo'),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Status: ${_getStatusLabel(atendimento.status ?? 'ativo')}",
                    style: TextStyle(
                      color: _getStatusColor(atendimento.status ?? 'ativo'),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "Data: ${_formatDate(atendimento.data)}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () async {
          await Navigator.pushNamed(
            context,
            '/details',
            arguments: atendimento,
          );
        },
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(context, value, atendimento),
          itemBuilder: (context) => [
            // NOVO: Opção de realizar atendimento
            if (atendimento.status != 'finalizado' &&
                atendimento.status != 'inativo')
              const PopupMenuItem(
                value: 'perform',
                child: Row(
                  children: [
                    Icon(Icons.play_circle_outline,
                        size: 18, color: Colors.blue),
                    SizedBox(width: 8),
                    Text("Realizar", style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text("Editar"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(Icons.swap_horiz, size: 18),
                  SizedBox(width: 8),
                  Text("Mudar Status"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Excluir", style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleMenuAction(
    BuildContext context,
    String action,
    Atendimento atendimento,
  ) async {
    final cubit = context.read<AtendimentoCubit>();

    switch (action) {
      case 'perform':
        await Navigator.pushNamed(
          context,
          '/perform',
          arguments: atendimento,
        );
        await cubit.loadAtendimentos();
        break;

      case 'edit':
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: cubit,
              child: CreateAtendimentoPage(atendimento: atendimento),
            ),
          ),
        );
        break;

      case 'toggle':
        await _showStatusDialog(context, atendimento);
        break;

      case 'delete':
        final confirm = await _showDeleteDialog(context);
        if (confirm == true && atendimento.id != null) {
          await cubit.delete(atendimento.id!);
        }
        break;
    }
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text(
          'Deseja realmente excluir este atendimento?\n\n'
          'Esta ação marcará o atendimento como inativo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  Future<void> _showStatusDialog(
    BuildContext context,
    Atendimento atendimento,
  ) async {
    final statuses = [
      {'value': 'ativo', 'label': 'Ativo', 'icon': Icons.check_circle},
      {
        'value': 'andamento',
        'label': 'Em andamento',
        'icon': Icons.hourglass_empty
      },
      {'value': 'finalizado', 'label': 'Finalizado', 'icon': Icons.done_all},
      {'value': 'inativo', 'label': 'Inativo', 'icon': Icons.cancel},
    ];

    final selected = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((status) {
            final isSelected = atendimento.status == status['value'];
            return ListTile(
              leading: Icon(
                status['icon'] as IconData,
                color: isSelected ? Theme.of(context).primaryColor : null,
              ),
              title: Text(
                status['label'] as String,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, status['value']),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );

    if (selected != null && selected != atendimento.status) {
      final updated = atendimento.copyWith(status: selected);
      await context.read<AtendimentoCubit>().update(updated);
    }
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterButton(
              "Todos",
              Icons.list,
              () => context.read<AtendimentoCubit>().loadAtendimentos(),
            ),
            const SizedBox(width: 8),
            _filterButton(
              "Ativos",
              Icons.check_circle,
              () => context.read<AtendimentoCubit>().filterByStatus("ativo"),
            ),
            const SizedBox(width: 8),
            _filterButton(
              "Em andamento",
              Icons.hourglass_empty,
              () =>
                  context.read<AtendimentoCubit>().filterByStatus("andamento"),
            ),
            const SizedBox(width: 8),
            _filterButton(
              "Finalizados",
              Icons.done_all,
              () =>
                  context.read<AtendimentoCubit>().filterByStatus("finalizado"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ativo':
        return Colors.green;
      case 'andamento':
        return Colors.orange;
      case 'finalizado':
        return Colors.blue;
      case 'inativo':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'ativo':
        return Icons.check_circle;
      case 'andamento':
        return Icons.hourglass_empty;
      case 'finalizado':
        return Icons.done_all;
      case 'inativo':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'ativo':
        return 'Ativo';
      case 'andamento':
        return 'Em andamento';
      case 'finalizado':
        return 'Finalizado';
      case 'inativo':
        return 'Inativo';
      default:
        return status;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
