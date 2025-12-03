import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entity/atendimento.dart';

class SqliteDataSource {
  final Database _db;

  SqliteDataSource._(this._db);

  static Future<SqliteDataSource> create() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'atendimentos.db');

    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE atendimentos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            status TEXT,
            data TEXT,
            imagePath TEXT,
            observacoes TEXT
          )
        ''');
      },
    );

    return SqliteDataSource._(db);
  }

  Future<List<Atendimento>> getAll() async {
    final rows = await _db.query('atendimentos', orderBy: 'data DESC');
    return rows.map((r) => Atendimento.fromMap(r)).toList();
  }

  Future<void> insert(Atendimento a) async {
    await _db.insert('atendimentos', a.toMap());
  }

  Future<void> update(Atendimento a) async {
    await _db.update(
      'atendimentos',
      a.toMap(),
      where: 'id = ?',
      whereArgs: [a.id],
    );
  }

  Future<void> delete(int id) async {
    await _db.update(
      'atendimentos',
      {'status': 'inativo'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Atendimento>> filterByStatus(String status) async {
    final rows = await _db.query(
      'atendimentos',
      where: 'status = ?',
      whereArgs: [status],
    );
    return rows.map((r) => Atendimento.fromMap(r)).toList();
  }

  Future<void> close() async {
    await _db.close();
  }
}
