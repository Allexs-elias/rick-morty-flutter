import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> obtenerPersonajes({ // Función para obtener los personajes de la API de Rick y Morty, con parámetros opcionales para la página, el nombre y el estado
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

    final respuesta = await http.get(url).timeout( // Realiza la solicitud HTTP a la API y espera una respuesta, con un tiempo de espera de 15 segundos
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

    throw Exception('No se pudieron obtener los personajes'); // Lanza una excepción si la respuesta no es exitosa y no es un error 404
  }
}