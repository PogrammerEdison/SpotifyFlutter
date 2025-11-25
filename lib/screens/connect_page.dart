import 'package:flutter/material.dart';
import '../spotify_auth.dart';
import '../spotify_api.dart';
import 'dart:developer' as developer;

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  String? accessToken;
  List<dynamic>? playlists;
  List<dynamic>? likedSongs;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connect to Spotify')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: connectAndFetch,
              child: Text(accessToken == null ? "Connect to Spotify" : "Refresh Data"),
            ),
            const SizedBox(height: 20),
            if (loading) const CircularProgressIndicator(),
            if (playlists != null)
              Text("Playlists: ${playlists!.map((p) => p['name']).join(', ')}"),
            if (likedSongs != null)
              Text("Liked Songs: ${likedSongs!.map((s) => s['track']['name']).join(', ')}"),
          ],
        ),
      ),
    );
  }

  Future<void> connectAndFetch() async {
    setState(() => loading = true);

    try {
      accessToken = await connectToSpotify();

      if (accessToken != null) {
        playlists = await getPlaylists(accessToken!);
        likedSongs = await getLikedSongs(accessToken!);
      }
    } catch (e) {
      developer.log("Spotify error: $e");
    } finally {
      setState(() => loading = false);
    }
  }
}
