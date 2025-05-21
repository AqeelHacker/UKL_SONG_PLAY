import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song_model.dart';
import '../models/playlist_model.dart';

class PlaylistService {
  static Future<List<PlaylistModel>> fetchPlaylists() async {
    final response = await http.get(
      Uri.parse("https://learn.smktelkom-mlg.sch.id/ukl2/playlists"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List playlistData = data['data'];
      return playlistData.map((e) => PlaylistModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil playlist");
    }
  }

  static Future<List<SongModel>> fetchSongsByPlaylistId(String playlistId, {String? search}) async {
    final baseUrl = "https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song-list/$playlistId";
    final url = Uri.parse(
      search != null && search.isNotEmpty
        ? "$baseUrl?search=${Uri.encodeQueryComponent(search)}"
        : baseUrl
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List songData = data['data'];
      return songData.map((e) => SongModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal membuka playlist");
    }
  }

  static Future<SongModel> fetchSongById(String songId) async {
    final response = await http.get(
      Uri.parse("https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song/$songId"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SongModel.fromJson(data['data']);
    } else {
      throw Exception("Gagal melihat detail lagu");
    }
  }
}
