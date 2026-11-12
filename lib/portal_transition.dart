import 'package:flutter/material.dart';

class PortalRoute extends PageRouteBuilder<void> { // Pagina de transición personalizada para la animación de portal
  PortalRoute({required Widget pantalla})
      : super(
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 450),
          pageBuilder: (_, __, ___) => pantalla,
          transitionsBuilder: (_, animation, __, child) {
            final expansion = animation.drive(
              CurveTween(
                curve: const Interval(
                  0,
                  0.75,
                  curve: Curves.easeInCubic,
                ),
              ),
            );

            final entrada = animation.drive(
              CurveTween(
                curve: const Interval(
                  0.55,
                  1,
                  curve: Curves.easeOut,
                ),
              ),
            );

            return Stack( // Stack para superponer la animación de portal y la pantalla de destino
              fit: StackFit.expand,
              children: [
                IgnorePointer(
                  child: LayoutBuilder(
                    builder: (context, espacio) {
                      final lado = espacio.biggest.longestSide * 1.6;

                      return Center(
                        child: OverflowBox(
                          minWidth: lado,
                          maxWidth: lado,
                          minHeight: lado,
                          maxHeight: lado,
                          child: ScaleTransition(
                            scale: expansion,
                            child: RotationTransition(
                              turns: animation,
                              child: SizedBox.square(
                                dimension: lado,
                                child: const CustomPaint(
                                  painter: PortalPainter(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                FadeTransition(
                  opacity: entrada,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.94,
                      end: 1,
                    ).animate(entrada),
                    child: child,
                  ),
                ),
              ],
            );
          },
        );
}

class PortalPainter extends CustomPainter { // Pintor personalizado para dibujar la animación de portal
  const PortalPainter();

  @override
  void paint(Canvas canvas, Size size) { // Dibuja el portal en el canvas, con un gradiente radial y líneas concéntricas
    final centro = Offset(size.width / 2, size.height / 2);
    final radio = size.shortestSide / 2;

    final fondo = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFE8FF96),
          Color(0xFFA9F542),
          Color(0xFF52CC29),
          Color(0xFF228B22),
          Color(0x00228B22),
        ],
        stops: [0, 0.35, 0.65, 0.88, 1],
      ).createShader(
        Rect.fromCircle(center: centro, radius: radio),
      );

    canvas.drawCircle(centro, radio, fondo);

    final linea = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = radio * 0.018;

    for (int i = 0; i < 18; i++) {
      linea.color = i.isEven
          ? const Color(0xFFDCFF79)
          : const Color(0xFF358E20);

      canvas.drawArc(
        Rect.fromCircle(
          center: centro,
          radius: radio * (i + 1) / 20,
        ),
        i * 0.85,
        2.8,
        false,
        linea,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PortalPainter oldDelegate) => false;
}