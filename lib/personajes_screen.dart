import 'package:flutter/material.dart';
import 'api_service.dart';
import 'detalle_personaje.dart';
import 'portal_transition.dart';
import 'tarjeta_personaje.dart';

class PersonajesScreen extends StatefulWidget {
  const PersonajesScreen({super.key});

  @override
  State<PersonajesScreen> createState() => _PersonajesScreenState();
}

class _PersonajesScreenState extends State<PersonajesScreen> {
  final buscador = TextEditingController();

  List<dynamic> personajes = [];
  bool cargando = true;
  String? error;
  String busqueda = '';
  String estado = '';
  int pagina = 1;
  int totalPaginas = 1;

  @override
  void initState() {
    super.initState();
    cargarPersonajes();
  }

  Future<void> cargarPersonajes() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final datos = await ApiService.obtenerPersonajes(
        pagina: pagina,
        nombre: busqueda,
        estado: estado,
      );

      if (!mounted) return;

      setState(() {
        personajes = datos['results'];
        totalPaginas = datos['info']['pages'];
        cargando = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        error = 'No pudimos cargar los personajes.\n'
            'Revisa tu conexión e inténtalo otra vez.';
        cargando = false;
      });
    }
  }

  void buscar() {
    if (cargando) return;
    busqueda = buscador.text.trim();
    pagina = 1;
    FocusScope.of(context).unfocus();
    cargarPersonajes();
  }

  void cambiarPagina(int cambio) {
    pagina += cambio;
    cargarPersonajes();
  }

  void abrirPersonaje(Map<String, dynamic> personaje) {
    FocusScope.of(context).unfocus();

    Navigator.of(context).push(
      PortalRoute(
        pantalla: DetallePersonaje(personaje: personaje),
      ),
    );
  }

  @override
  void dispose() {
    buscador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EXPLORA EL MULTIVERSO',
                    style: TextStyle(
                      color: Color(0xFFB5ED63),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Rick y Morty',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Caras conocidas. Universos extraños.',
                    style: TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(height: 24),
                  campoBusqueda(),
                  const SizedBox(height: 14),
                  filtros(),
                  const SizedBox(height: 16),
                  Expanded(child: contenido()),
                  const SizedBox(height: 8),
                  paginacion(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget campoBusqueda() {
    return TextField(
      controller: buscador,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => buscar(),
      decoration: InputDecoration(
        hintText: 'Busca un personaje...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: cargando ? null : buscar,
          icon: const Icon(Icons.arrow_forward),
        ),
        filled: true,
        fillColor: const Color(0xFF1C2720),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget filtros() {
    final opciones = {
      'Todos': '',
      'Vivos': 'alive',
      'Muertos': 'dead',
      'Desconocidos': 'unknown',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: opciones.entries.map((opcion) {
          final seleccionado = estado == opcion.value;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(opcion.key),
              selected: seleccionado,
              showCheckmark: false,
              selectedColor: const Color(0xFFB5ED63),
              backgroundColor: const Color(0xFF1C2720),
              labelStyle: TextStyle(
                color: seleccionado
                    ? const Color(0xFF101713)
                    : Colors.white70,
                fontWeight: FontWeight.w600,
              ),
              onSelected: cargando
                  ? null
                  : (_) {
                      estado = opcion.value;
                      pagina = 1;
                      cargarPersonajes();
                    },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget contenido() {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off,
                size: 42,
                color: Colors.white54,
              ),
              const SizedBox(height: 16),
              Text(error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: cargarPersonajes,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (personajes.isEmpty) {
      return const Center(
        child: Text(
          'No encontramos personajes con esos filtros.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, espacio) {
        final ancho = espacio.maxWidth;
        final columnas = ancho > 800
            ? 4
            : ancho > 550
                ? 3
                : ancho < 300
                    ? 1
                    : 2;

        return GridView.builder(
          itemCount: personajes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnas,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 260,
          ),
          itemBuilder: (context, index) {
            final personaje = personajes[index];

            return TarjetaPersonaje(
              personaje: personaje,
              onTap: () => abrirPersonaje(personaje),
            );
          },
        );
      },
    );
  }

  Widget paginacion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton.filledTonal(
          onPressed: !cargando && error == null && pagina > 1
              ? () => cambiarPagina(-1)
              : null,
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          'Página $pagina de $totalPaginas',
          style: const TextStyle(color: Colors.white60),
        ),
        IconButton.filledTonal(
          onPressed:
              !cargando && error == null && pagina < totalPaginas
                  ? () => cambiarPagina(1)
                  : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}