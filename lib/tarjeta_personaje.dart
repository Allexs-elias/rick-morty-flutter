import 'package:flutter/material.dart';

class TarjetaPersonaje extends StatelessWidget {
  final Map<String, dynamic> personaje;
  final VoidCallback onTap;

  const TarjetaPersonaje({
    super.key,
    required this.personaje,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final estado = personaje['status'];

    final color = estado == 'Alive'
        ? const Color(0xFFB5ED63)
        : estado == 'Dead'
            ? const Color(0xFFFF7979)
            : Colors.grey;

    final textoEstado = estado == 'Alive'
        ? 'Vivo'
        : estado == 'Dead'
            ? 'Muerto'
            : 'Desconocido';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFF1C2720),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  personaje['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.person_outline, size: 50),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      personaje['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.circle, color: color, size: 8),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            textoEstado,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}