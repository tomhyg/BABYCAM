// lib/ui/widgets/baby_avatar.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/baby_profile_provider.dart';
import '../../core/models/baby_profile.dart';

class BabyAvatar extends StatelessWidget {
  final double size;
  final bool showEditButton;
  final VoidCallback? onTap;

  const BabyAvatar({
    Key? key,
    this.size = 48,
    this.showEditButton = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BabyProfileProvider>(
      builder: (context, babyProvider, child) {
        return GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size * 0.25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size * 0.25),
                  child: babyProvider.hasProfile
                      ? _buildCustomAvatar(babyProvider.profile, size)
                      : _buildDefaultAvatar(size),
                ),
              ),
              
              // Bouton d'édition
              if (showEditButton)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: size * 0.3,
                    height: size * 0.3,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: size * 0.15,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomAvatar(BabyProfile profile, double size) {
    return CustomPaint(
      size: Size(size, size),
      painter: BabyAvatarPainter(profile),
    );
  }

  Widget _buildDefaultAvatar(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade200,
            Colors.purple.shade200,
          ],
        ),
      ),
      child: Icon(
        Icons.baby_changing_station,
        size: size * 0.6,
        color: Colors.white,
      ),
    );
  }
}

// Painter personnalisé pour dessiner l'avatar du bébé
class BabyAvatarPainter extends CustomPainter {
  final BabyProfile profile;

  BabyAvatarPainter(this.profile);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Arrière-plan
    final backgroundPaint = Paint()
      ..color = const Color(0xFFE3F2FD);
    canvas.drawCircle(center, radius, backgroundPaint);

    // Couleur de peau
    final skinColor = BabyAvatarOptions.skinToneColors[profile.skinTone] ?? 
                      BabyAvatarOptions.skinToneColors['light']!;
    
    // Visage
    final facePaint = Paint()
      ..color = skinColor;
    canvas.drawCircle(center, radius * 0.8, facePaint);

    // Cheveux (si pas chauve)
    if (profile.hairStyle != 'bald') {
      final hairColor = BabyAvatarOptions.hairStyleColors[profile.hairStyle] ?? 
                        BabyAvatarOptions.hairStyleColors['blonde']!;
      final hairPaint = Paint()
        ..color = hairColor;
      
      // Dessiner une forme de cheveux simple
      final hairPath = Path();
      hairPath.addOval(Rect.fromCircle(
        center: Offset(center.dx, center.dy - radius * 0.3),
        radius: radius * 0.6,
      ));
      canvas.drawPath(hairPath, hairPaint);
    }

    // Yeux
    final eyeColor = BabyAvatarOptions.eyeColorColors[profile.eyeColor] ?? 
                     BabyAvatarOptions.eyeColorColors['blue']!;
    final eyePaint = Paint()
      ..color = eyeColor;
    
    // Œil gauche
    canvas.drawCircle(
      Offset(center.dx - radius * 0.25, center.dy - radius * 0.1),
      radius * 0.08,
      eyePaint,
    );
    
    // Œil droit
    canvas.drawCircle(
      Offset(center.dx + radius * 0.25, center.dy - radius * 0.1),
      radius * 0.08,
      eyePaint,
    );

    // Sourire
    final smilePaint = Paint()
      ..color = Colors.pink.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    final smilePath = Path();
    smilePath.addArc(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.1),
        width: radius * 0.4,
        height: radius * 0.3,
      ),
      0,
      3.14159, // π
    );
    canvas.drawPath(smilePath, smilePaint);

    // Joues roses
    final cheekPaint = Paint()
      ..color = Colors.pink.shade200.withOpacity(0.6);
    
    // Joue gauche
    canvas.drawCircle(
      Offset(center.dx - radius * 0.4, center.dy + radius * 0.1),
      radius * 0.1,
      cheekPaint,
    );
    
    // Joue droite
    canvas.drawCircle(
      Offset(center.dx + radius * 0.4, center.dy + radius * 0.1),
      radius * 0.1,
      cheekPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! BabyAvatarPainter || 
           oldDelegate.profile != profile;
  }
}

// Widget d'avatar simple avec initiales
class BabyAvatarSimple extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  const BabyAvatarSimple({
    Key? key,
    this.size = 48,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BabyProfileProvider>(
      builder: (context, babyProvider, child) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: babyProvider.hasProfile 
                  ? babyProvider.skinToneColor
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(size * 0.25),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                babyProvider.hasProfile 
                    ? babyProvider.shortName
                    : 'B',
                style: TextStyle(
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}