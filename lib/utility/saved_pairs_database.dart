import 'package:big_red_button/utility/saved_pairs_holder.dart';
import 'package:russian_words/russian_words.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class SavedPairsDatabase {
  Database database;

  SavedPairsDatabase() {
    _openPairsDatabase();
  }

  void _openPairsDatabase() async {
    database =
        await openDatabase(join(await getDatabasesPath(), 'pairs_database.db'),
            onCreate: (db, version) {
      return db.execute('CREATE TABLE pairs(pair TEXT PRIMARY KEY)');
    }, version: 1);
  }

  Future<void> addPair(WordPair pair) async {
    final Database db = database;

    await db.insert('pairs', {'pair': _buildPairString(pair)},
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<void> addPairsHolder(SavedPairsHolder pairsHolder) async {
    final Database db = database;

    pairsHolder.toMapsSet().forEach((pair) async {
      await db.insert('pairs', pair,
          conflictAlgorithm: ConflictAlgorithm.abort);
    });
  }

  Future<List<WordPair>> getPairs() async {
    final Database db = database;

    final List<Map<String, dynamic>> maps = await db.query('pairs');

    return List.generate(maps.length, (index) {
      List<String> splitPair = maps[index]['pair'].toString().split(' ');
      return WordPair(splitPair[0], splitPair[1]);
    });
  }

  Future<void> removePair(WordPair pair) async {
    final Database db = database;

    return db.delete('pairs',
        where: 'pair = ?', whereArgs: [_buildPairString(pair)]);
  }

  String _buildPairString(WordPair pair) {
    return pair.first + ' ' + pair.second;
  }
}
