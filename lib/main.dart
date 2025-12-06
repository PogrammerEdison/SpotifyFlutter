import 'package:flutter/material.dart';
import 'screens/landing_screen.dart';
import 'screens/connect_page.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Shuffle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/auth-callback': (context) =>
            const ConnectPage(), // placeholder for now
      },
    );
  }
}
