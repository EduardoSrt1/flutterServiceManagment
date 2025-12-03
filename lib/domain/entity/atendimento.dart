class Atendimento {
  final int? id;
  final String titulo;
  final String status; // 'ativo', 'andamento', 'finalizado', 'inativo'
  final DateTime data;
  final String? imagePath;
  final String? observacoes;

  Atendimento({
    this.id,
    required this.titulo,
    required this.status,
    required this.data,
    this.imagePath,
    this.observacoes,
  });

  Atendimento copyWith({
    int? id,
    String? titulo,
    String? status,
    DateTime? data,
    String? imagePath,
    String? observacoes,
  }) {
    return Atendimento(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      status: status ?? this.status,
      data: data ?? this.data,
      imagePath: imagePath ?? this.imagePath,
      observacoes: observacoes ?? this.observacoes,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'titulo': titulo,
        'status': status,
        'data': data.toIso8601String(),
        'imagePath': imagePath,
        'observacoes': observacoes,
      };

  static Atendimento fromMap(Map<String, dynamic> m) {
    return Atendimento(
      id: m['id'] as int?,
      titulo: m['titulo'] ?? '',
      status: m['status'] ?? 'ativo',
      data: DateTime.tryParse(m['data'] ?? '') ?? DateTime.now(),
      imagePath: m['imagePath'],
      observacoes: m['observacoes'],
    );
  }
}
