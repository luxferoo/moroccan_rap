import 'dart:convert';

import 'track_cache.dart';
import 'track_source.dart';
import '../../models/track.dart';
import '../../Helpers/db_provider.dart';

class TrackDb implements TrackSource, TrackCache{
  @override
  addTrack(Track track) {
    // TODO: implement addTrack
    return null;
  }

  @override
  Future<int> clear() {
    return dbProvider.db.delete(TABLE_TRACK);
  }

  @override
  Future<List<int>> fetchLastIds() {
    return null;
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
    );
    if (maps.length > 0) {
      List<Track> trackList = maps.map((track){
        return Track.fromMap(jsonDecode(json.encode(track)));
      });
      return trackList;
    }
    return null;
  }

  @override
  Future<List<Track>> fetchLastTracks() {
    // TODO: implement fetchLastTracks
    return null;
  }

}
