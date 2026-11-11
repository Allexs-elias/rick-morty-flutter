import 'package:flutter/material.dart';
import 'personajes_screen.dart';

void main() {
  runApp(const RickMortyApp());
}

class RickMortyApp extends StatelessWidget {
  const RickMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rick y Morty',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101713),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB5ED63),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const PersonajesScreen(),
    );
  }
}