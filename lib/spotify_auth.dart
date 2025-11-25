import 'dart:convert';
import 'dart:math';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

//PKCE verifier
String generateVerifier() {
  final random = Random.secure();
  final values = List<int>.generate(64, (i) => random.nextInt(256));
  return base64UrlEncode(values).replaceAll('=', '');
}

//generate a challenge from the verifier
String generateChallenge(String verifier) {
  final bytes = utf8.encode(verifier);
  final digest = sha256.convert(bytes);
  return base64UrlEncode(digest.bytes).replaceAll('=', '');
}

//connect to spotify
Future<String?> connectToSpotify() async {
  final clientId = "32d59d35e1474a2a83213d215d6887a1";
  final redirectUri = "http://127.0.0.1:52998/#/connect-callback";
  final scopes =
      "playlist-read-private playlist-read-collaborative user-library-read user-modify-playback-state";

  final verifier = generateVerifier();
  final challenge = generateChallenge(verifier);

  final authUrl =
      "https://accounts.spotify.com/authorize"
      "?client_id=$clientId"
      "&response_type=code"
      "&redirect_uri=$redirectUri"
      "&code_challenge_method=S256"
      "&code_challenge=$challenge"
      "&scope=$scopes";

  final result = await FlutterWebAuth2.authenticate(
    url: authUrl,
    callbackUrlScheme: "http",
  );

  final code = Uri.parse(
    result,
  ).queryParameters['code']; //authorization token is generated based on challenge
  if (code == null) return null;

  //send authorization token with verifier to prove verifier owns challenge
  final response = await http.post(
    Uri.parse("https://accounts.spotify.com/api/token"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: {
      "client_id": clientId,
      "grant_type": "authorization_code",
      "code": code,
      "redirect_uri": redirectUri,
      "code_verifier": verifier,
    },
  );

  final jsonResponse = jsonDecode(response.body);
  return jsonResponse["access_token"];
}
