// lib/ui/widgets/animated_gradient_background.dart

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color>? colors;
  final Duration duration;
  final AlignmentGeometry? beginAlignment;
  final AlignmentGeometry? endAlignment;
  
  const AnimatedGradientBackground({
    Key? key,
    required this.child,
    this.colors,
    this.duration = const Duration(seconds: 10),
    this.beginAlignment,
    this.endAlignment,
  }) : super(key: key);

  @override
  _AnimatedGradientBackgroundState createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignment;
  late Animation<Alignment> _bottomAlignment;
  late List<Color> _colors;
  
  @override
  void initState() {
    super.initState();
    
    _colors = widget.colors ?? [
      AppColors.primary,
      AppColors.primary.withOpacity(0.5),
      Color.lerp(AppColors.primary, AppColors.accent, 0.5) ?? AppColors.primary,
    ];
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);
    
    final defaultBeginAlignment = widget.beginAlignment ?? Alignment.topLeft;
    final defaultEndAlignment = widget.endAlignment ?? Alignment.bottomRight;
    
    // Animation pour l'alignement du haut du dégradé
    _topAlignment = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: defaultBeginAlignment as Alignment,
          end: Alignment.topRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomLeft,
          end: defaultBeginAlignment as Alignment,
        ),
        weight: 1,
      ),
    ]).animate(_controller);
    
    // Animation pour l'alignement du bas du dégradé
    _bottomAlignment = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: defaultEndAlignment as Alignment,
          end: Alignment.bottomLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topRight,
          end: defaultEndAlignment as Alignment,
        ),
        weight: 1,
      ),
    ]).animate(_controller);
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
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _colors,
              begin: _topAlignment.value,
              end: _bottomAlignment.value,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}