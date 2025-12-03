// lib/presentation/pages/create_atendimento_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/atendimento_cubit.dart';
import '../../domain/entity/atendimento.dart';

class CreateAtendimentoPage extends StatefulWidget {
  final Atendimento? atendimento;

  const CreateAtendimentoPage({super.key, this.atendimento});

  @override
  State<CreateAtendimentoPage> createState() => _CreateAtendimentoPageState();
}

class _CreateAtendimentoPageState extends State<CreateAtendimentoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _observacoesController;
  String _status = 'ativo';
  bool _initialized = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _observacoesController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeInitFromWidget());
  }

  void _maybeInitFromWidget() {
    if (_initialized) return;
    final atendimento = widget.atendimento;
    if (atendimento != null) {
      _tituloController.text = atendimento.titulo ?? '';
      _status = atendimento.status ?? 'ativo';
      _observacoesController.text = atendimento.observacoes ?? '';
    }
    _initialized = true;
    setState(() {});
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final titulo = _tituloController.text.trim();
      final observacoes = _observacoesController.text.trim();
      final cubit = context.read<AtendimentoCubit>();
      final isEditing = widget.atendimento != null;

      if (!isEditing) {
        // CREATE
        final atendimento = Atendimento(
          titulo: titulo,
          status: _status,
          data: DateTime.now(),
          observacoes: observacoes.isEmpty ? null : observacoes,
        );
        await cubit.create(atendimento);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Atendimento criado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // UPDATE
        final existing = widget.atendimento!;
        final updated = existing.copyWith(
          titulo: titulo,
          status: _status,
          observacoes: observacoes.isEmpty ? null : observacoes,
        );
        await cubit.update(updated);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Atendimento atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.atendimento != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Atendimento' : 'Novo Atendimento'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card para informações básicas
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informações Básicas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _tituloController,
                          decoration: InputDecoration(
                            labelText: 'Título *',
                            hintText: 'Digite o título do atendimento',
                            prefixIcon: const Icon(Icons.title),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'O título é obrigatório'
                              : null,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _status,
                          decoration: InputDecoration(
                            labelText: 'Status',
                            prefixIcon: Icon(
                              _getStatusIcon(_status),
                              color: _getStatusColor(_status),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'ativo',
                              child: Text('Ativo'),
                            ),
                            DropdownMenuItem(
                              value: 'andamento',
                              child: Text('Em andamento'),
                            ),
                            DropdownMenuItem(
                              value: 'finalizado',
                              child: Text('Finalizado'),
                            ),
                            DropdownMenuItem(
                              value: 'inativo',
                              child: Text('Inativo'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _status = v);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _observacoesController,
                          decoration: InputDecoration(
                            labelText: 'Observações',
                            hintText: 'Digite observações adicionais',
                            prefixIcon: const Icon(Icons.notes),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 4,
                          textInputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Botões de ação
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            _isSaving ? null : () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        label: const Text('Cancelar'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _save,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(_isSaving ? 'Salvando...' : 'Salvar'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
}
