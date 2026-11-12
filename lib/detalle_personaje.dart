import 'package:flutter/material.dart';

class DetallePersonaje extends StatelessWidget { // Pantalla de detalle de un personaje, que muestra información detallada sobre el personaje seleccionado
  final Map<String, dynamic> personaje;

  const DetallePersonaje({
    super.key,
    required this.personaje,
  });

  @override
  Widget build(BuildContext context) { // Crea la estructura principal de la pantalla de detalle del personaje, incluyendo la imagen, nombre, estado, especie, género, origen y última ubicación
    final estado = personaje['status'] == 'Alive'
        ? 'Vivo'
        : personaje['status'] == 'Dead'
            ? 'Muerto'
            : 'Desconocido';

    final genero = {
      'Male': 'Masculino',
      'Female': 'Femenino',
      'Genderless': 'Sin género',
      'unknown': 'Desconocido',
    }[personaje['gender']] ?? personaje['gender'];

    return Scaffold( // Scaffold para la pantalla de detalle del personaje, con un AppBar y un cuerpo que contiene la información del personaje
      appBar: AppBar(
        title: const Text('Ficha del personaje'),
        backgroundColor: const Color(0xFF101713),
      ),
      body: SingleChildScrollView( // Permite que el contenido de la pantalla de detalle del personaje sea desplazable si es necesario
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    personaje['image'],
                    width: double.infinity,
                    height: 320,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(
                      height: 320,
                      child: Center(
                        child: Icon(Icons.person_outline, size: 80),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'PERSONAJE #${personaje['id']}',
                  style: const TextStyle(
                    color: Color(0xFFB5ED63),
                    letterSpacing: 2,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  personaje['name'],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2720),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      dato(Icons.favorite_outline, 'Estado', estado),
                      const Divider(height: 28),
                      dato(
                        Icons.person_outline,
                        'Especie',
                        personaje['species'],
                      ),
                      const Divider(height: 28),
                      dato(Icons.badge_outlined, 'Género', genero),
                      const Divider(height: 28),
                      dato(
                        Icons.public,
                        'Origen',
                        nombreLugar(personaje['origin']['name']),
                      ),
                      const Divider(height: 28),
                      dato(
                        Icons.location_on_outlined,
                        'Última ubicación',
                        nombreLugar(personaje['location']['name']),
                      ),
                      const Divider(height: 28),
                      dato(
                        Icons.tv,
                        'Episodios en los que aparece',
                        '${personaje['episode'].length}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String nombreLugar(String nombre) { // Función para traducir el nombre del lugar, devolviendo "Desconocido" si el nombre es "unknown"
    return nombre == 'unknown' ? 'Desconocido' : nombre;
  }

  Widget dato(IconData icono, String titulo, String valor) { // Widget para mostrar un dato del personaje, con un icono, un título y un valor
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, color: const Color(0xFFB5ED63), size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(valor, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}