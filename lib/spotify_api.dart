import 'package:http/http.dart' as http;
import 'dart:convert';

//fetch playlists
Future<List<dynamic>> getPlaylists(String accessToken) async {
  final response = await http.get(
    Uri.parse("https://api.spotify.com/v1/me/playlists"),
    headers: {"Authorization": "Bearer $accessToken"},
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return jsonData['items'];
  } else {
    throw Exception("Failed to fetch playlists: ${response.statusCode}");
  }
}

//fetch liked songs
Future<List<dynamic>> getLikedSongs(String accessToken) async {
  final response = await http.get(
    Uri.parse("https://api.spotify.com/v1/me/tracks"),
    headers: {"Authorization": "Bearer $accessToken"},
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return jsonData['items'];
  } else {
    throw Exception("Failed to fetch liked songs: ${response.statusCode}");
  }
}

//queue a song
Future<void> queueTrack(String accessToken, String trackUri) async {
  final response = await http.post(
    Uri.parse("https://api.spotify.com/v1/me/player/queue?uri=$trackUri"),
    headers: {"Authorization": "Bearer $accessToken"},
  );

  if (response.statusCode != 204) {
    throw Exception("Failed to queue track: ${response.statusCode}");
  }
}
