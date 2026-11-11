import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> obtenerPersonajes({
    int pagina = 1,
    String nombre = '',
    String estado = '',
  }) async {
    final url = Uri.https(
      'rickandmortyapi.com',
      '/api/character',
      {
        'page': '$pagina',
        'name': nombre,
        if (estado.isNotEmpty) 'status': estado,
      },
    );

    final respuesta = await http.get(url).timeout(
      const Duration(seconds: 15),
    );

    if (respuesta.statusCode == 200) {
      return jsonDecode(respuesta.body) as Map<String, dynamic>;
    }

    if (respuesta.statusCode == 404) {
      return {
        'results': [],
        'info': {'pages': 1},
      };
    }

    throw Exception('No se pudieron obtener los personajes');
  }
}