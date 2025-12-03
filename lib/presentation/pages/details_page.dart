import 'package:flutter/material.dart';
import '../../domain/entity/atendimento.dart';

class AtendimentoDetailsPage extends StatelessWidget {
  final Atendimento atendimento;

  const AtendimentoDetailsPage({
    super.key,
    required this.atendimento,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Atendimento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              'Título',
              atendimento.titulo ?? 'Sem título',
              Icons.title,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              'Status',
              _getStatusLabel(atendimento.status ?? 'ativo'),
              Icons.info_outline,
              color: _getStatusColor(atendimento.status ?? 'ativo'),
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              'Data',
              _formatDate(atendimento.data),
              Icons.calendar_today,
            ),
            if (atendimento.observacoes != null &&
                atendimento.observacoes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildDetailCard(
                'Observações',
                atendimento.observacoes!,
                Icons.notes,
              ),
            ],
            if (atendimento.imagePath != null &&
                atendimento.imagePath!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Imagem',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  atendimento.imagePath!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 64),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon,
      {Color? color}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: color,
                      fontWeight:
                          color != null ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
