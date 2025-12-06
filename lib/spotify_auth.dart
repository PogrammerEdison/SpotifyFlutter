import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final scopes =
      "playlist-read-private playlist-read-collaborative user-library-read user-modify-playback-state";

  final verifier = generateVerifier();
  final challenge = generateChallenge(verifier);

  String redirectUri;

  if (kIsWeb) {
    // Web version
    redirectUri = "http://127.0.0.1:52998/auth-callback";
  } else {
    // Mobile version
    redirectUri = "myapp://auth-callback";
  }


  final authUrl =
      "https://accounts.spotify.com/authorize"
      "?client_id=$clientId"
      "&response_type=code"
      "&redirect_uri=$redirectUri"
      "&code_challenge_method=S256"
      "&code_challenge=$challenge"
      "&scope=$scopes";

  String? code;

  if (kIsWeb){
    await launchUrl(Uri.parse(authUrl), webOnlyWindowName: "_self");
    final uri = Uri.base;
    code = uri.queryParameters["code"];
    if (code == null) return null;
  }

  if (!kIsWeb) {
    final result = await FlutterWebAuth2.authenticate(
      url: authUrl,
      callbackUrlScheme: "myapp",
    );

    code = Uri.parse(result).queryParameters['code'];
    if (code == null) return null;
  }

  final response = await http.post(
    Uri.parse("https://accounts.spotify.com/api/token"),
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: {
      "client_id": clientId,
      "grant_type": "authorization_code",
      "code": code,
      "redirect_uri": redirectUri,
      "code_verifier": verifier,
    },
  );

  return jsonDecode(response.body)["access_token"];
}
