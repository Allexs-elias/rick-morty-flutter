import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rick_morty_app/main.dart';

void main() {
  testWidgets('La aplicación Rick y Morty inicia correctamente',
      (WidgetTester tester) async {
    // Inicio la aplicación.
    await tester.pumpWidget(const RickMortyApp());

    // Verifico que se muestre la aplicación.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
