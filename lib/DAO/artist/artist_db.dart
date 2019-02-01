import 'dart:convert';
import 'package:sqflite/sqflite.dart';

import '../../Helpers/db_provider.dart';
import '../../models/artist.dart';
import 'artist_source.dart';
import 'artist_cache.dart';

class ArtistDb implements ArtistSource, ArtistCache {
  @override
  Future<List<int>> fetchIds() async {
    return null;
  }

  @override
  Future<Artist> fetchArtist(int id) async {
    final maps = await dbProvider.db.query(
      TABLE_ARTIST,
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return Artist.fromMap(jsonDecode(json.encode(maps.single)));
    }
    return null;
  }

  @override
  addArtist(Artist artist) async {
    return dbProvider.db.insert(
      TABLE_ARTIST,
      artist.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<int> clear() {
    return dbProvider.db.delete(TABLE_ARTIST);
  }
}
