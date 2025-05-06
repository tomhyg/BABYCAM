// lib/ui/widgets/babycam_logo.dart

import 'package:flutter/material.dart';
import '../theme/app_colors_logo.dart';

class BabycamLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool animate;
  
  const BabycamLogo({
    Key? key,
    this.size = 100,
    this.showText = false,
    this.animate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: animate ? _AnimatedLogo(size: size) : _StaticLogo(size: size),
        ),
        if (showText) ...[
          const SizedBox(height: 16),
          Text(
            'BABYCAM AI',
            style: TextStyle(
              color: AppColorsLogo.accent,
              fontSize: size * 0.20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            'Surveillance intelligente pour bébé',
            style: TextStyle(
              color: AppColorsLogo.accent.withOpacity(0.7),
              fontSize: size * 0.10,
            ),
          ),
        ],
      ],
    );
  }
}

class BabycamLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double centerX = width / 2;
    final double centerY = height / 2;
    
    // Définition des peintures
    final Paint mentePaint = Paint()
      ..color = AppColorsLogo.secondary
      ..style = PaintingStyle.fill;
    
    final Paint lavandePaint = Paint()
      ..color = AppColorsLogo.primary
      ..style = PaintingStyle.fill;
    
    final Paint bluePaint = Paint()
      ..color = AppColorsLogo.accent
      ..style = PaintingStyle.fill;
    
    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // Dessiner le berceau vert menthe (moitié inférieure)
    final Path cradlePath = Path()
      ..moveTo(width * 0.1, centerY)
      ..quadraticBezierTo(
        centerX, height * 0.9, 
        width * 0.9, centerY
      )
      ..lineTo(width * 0.85, centerY * 1.2)
      ..quadraticBezierTo(
        centerX, height * 0.75, 
        width * 0.15, centerY * 1.2
      )
      ..lineTo(width * 0.1, centerY)
      ..close();
    
    canvas.drawPath(cradlePath, mentePaint);
    
    // Dessiner les arcs du berceau
    final Path leftArcPath = Path()
      ..moveTo(width * 0.15, height * 0.35)
      ..quadraticBezierTo(
        width * 0.05, centerY, 
        width * 0.15, height * 0.65
      );
    
    canvas.drawPath(leftArcPath, mentePaint);
    
    final Path rightArcPath = Path()
      ..moveTo(width * 0.85, height * 0.35)
      ..quadraticBezierTo(
        width * 0.95, centerY, 
        width * 0.85, height * 0.65
      );
    
    canvas.drawPath(rightArcPath, mentePaint);
    
    // Dessiner la courbe lavande (sourcil)
    final Path eyebrowPath = Path()
      ..moveTo(width * 0.2, height * 0.4)
      ..quadraticBezierTo(
        centerX, height * 0.25, 
        width * 0.8, height * 0.4
      );
    
    canvas.drawPath(eyebrowPath, lavandePaint);
    
    // Dessiner l'œil (cercle bleu)
    canvas.drawCircle(
      Offset(centerX, centerY * 1.1),
      width * 0.15,
      bluePaint,
    );
    
    // Dessiner la pupille (cercle bleu foncé)
    canvas.drawCircle(
      Offset(centerX * 1.15, centerY),
      width * 0.08,
      Paint()..color = AppColorsLogo.accentDarker,
    );
    
    // Dessiner le reflet blanc
    canvas.drawCircle(
      Offset(centerX * 0.9, centerY * 0.9),
      width * 0.04,
      whitePaint,
    );
    
    // Dessiner le motif de connexion au-dessus (nodes)
    final double nodeSize = width * 0.06;
    final Paint nodePaint = Paint()
      ..color = AppColorsLogo.primary
      ..style = PaintingStyle.fill;
    
    // Node central en haut
    canvas.drawCircle(
      Offset(centerX, height * 0.2),
      nodeSize,
      nodePaint,
    );
    
    // Node gauche
    canvas.drawCircle(
      Offset(centerX * 0.7, height * 0.3),
      nodeSize,
      nodePaint,
    );
    
    // Node droit
    canvas.drawCircle(
      Offset(centerX * 1.3, height * 0.3),
      nodeSize,
      nodePaint,
    );
    
    // Node bas
    canvas.drawCircle(
      Offset(centerX, height * 0.4),
      nodeSize,
      nodePaint,
    );
    
    // Lignes de connexion entre les nodes
    final Paint linePaint = Paint()
      ..color = AppColorsLogo.primary
      ..strokeWidth = width * 0.015
      ..style = PaintingStyle.stroke;
    
    // Ligne haut vers gauche
    canvas.drawLine(
      Offset(centerX, height * 0.2),
      Offset(centerX * 0.7, height * 0.3),
      linePaint,
    );
    
    // Ligne haut vers droit
    canvas.drawLine(
      Offset(centerX, height * 0.2),
      Offset(centerX * 1.3, height * 0.3),
      linePaint,
    );
    
    // Ligne gauche vers bas
    canvas.drawLine(
      Offset(centerX * 0.7, height * 0.3),
      Offset(centerX, height * 0.4),
      linePaint,
    );
    
    // Ligne droit vers bas
    canvas.drawLine(
      Offset(centerX * 1.3, height * 0.3),
      Offset(centerX, height * 0.4),
      linePaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _StaticLogo extends StatelessWidget {
  final double size;
  
  const _StaticLogo({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColorsLogo.highlight,
            AppColorsLogo.backgroundLight,
          ],
          center: Alignment.center,
          radius: 0.7,
        ),
      ),
      child: Center(
        child: CustomPaint(
          size: Size(size * 0.9, size * 0.9),
          painter: BabycamLogoPainter(),
        ),
      ),
    );
  }
}

class _AnimatedLogo extends StatefulWidget {
  final double size;
  
  const _AnimatedLogo({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _glowAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    _rotateAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    _glowAnimation = Tween<double>(begin: 0.7, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColorsLogo.highlight,
                AppColorsLogo.backgroundLight,
              ],
              center: Alignment.center,
              radius: _glowAnimation.value,
            ),
          ),
          child: Center(
            child: Transform.scale(
              scale: _pulseAnimation.value,
              child: Transform.rotate(
                angle: _rotateAnimation.value,
                child: CustomPaint(
                  size: Size(widget.size * 0.9, widget.size * 0.9),
                  painter: BabycamLogoPainter(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}