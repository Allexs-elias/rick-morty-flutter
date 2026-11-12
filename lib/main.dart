import 'package:flutter/material.dart';
import 'personajes_screen.dart';

void main() {
  runApp(const RickMortyApp());
}

class RickMortyApp extends StatelessWidget { // Widget principal de la aplicación, que configura el tema y la pantalla inicial
  const RickMortyApp({super.key});

  @override
  Widget build(BuildContext context) { // Crea la estructura principal de la aplicación, incluyendo el tema y la pantalla inicial
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