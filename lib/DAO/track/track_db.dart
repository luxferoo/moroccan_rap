import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import 'track_cache.dart';
import 'track_source.dart';
import '../../models/track.dart';
import '../../Helpers/db_provider.dart';

class TrackDb implements TrackSource, TrackCache{
  @override
  addTrack(Track track) {
    return dbProvider.db.insert(
      TABLE_TRACK,
      track.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<int> clear() {
    return dbProvider.db.delete(TABLE_TRACK);
  }

  @override
  Future<Track> fetchTrack(int id) async {
    final maps = await dbProvider.db.query(
      TABLE_TRACK,
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return Track.fromMap(jsonDecode(json.encode(maps.single)));
    }
    return null;
  }

  @override
  Future<List<Track>> fetchTracksByArtistId(int id) async {
    final maps = await dbProvider.db.query(
      TABLE_TRACK,
      columns: null,
      where: "artistId = ?",
      whereArgs: [id],
      orderBy: "name ASC"
    );
    if (maps.length > 0) {
      List<Track> trackList = maps.map((track){
        return Track.fromMap(jsonDecode(json.encode(track)));
      }).toList();
      return trackList;
    }
    return null;
  }

  @override
  Future<List<Track>> fetchRecentTracks() {
    // TODO: implement fetchRecentTracks
    return null;
  }

  @override
  Future<List<Track>> fetchCarouselTracks() {
    // TODO: implement fetchCarouselTracks
    return null;
  }
}
