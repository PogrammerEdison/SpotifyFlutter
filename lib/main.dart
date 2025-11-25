import 'package:flutter/material.dart';
import 'screens/landing_screen.dart';
import 'screens/connect_page.dart';

void main() {
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
        '/connect-callback': (context) =>
            const ConnectPage(), // placeholder for now
      },
    );
  }
}
