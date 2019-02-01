import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

const TABLE_ARTIST = "Artist";
const TABLE_TRACK = "Track";

class _DbProvider {
  Database db;

  init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "moroccan_rap.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute('''CREATE TABLE $TABLE_ARTIST
        (
          id INTEGER PRIMARY KEY,
          picture TEXT,
          name TEXT,
          type TEXT
        )
        ''');
        newDb.execute('''CREATE TABLE $TABLE_TRACK
        (
          id INTEGER PRIMARY KEY,
          artistId INTEGER,
          album TEXT,
          name TEXT,
          artistName TEXT,
          picture TEXT,
          artistPicture TEXT,
          link TEXT,
          duration TEXT
        )
        ''');
      },
    );
  }
}

final dbProvider = _DbProvider();
