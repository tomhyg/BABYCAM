// lib/ui/widgets/bottom_navigation_modern.dart

import 'package:flutter/material.dart';

class BottomNavigationModern extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationItemData> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? selectedItemSize;
  final double? unselectedItemSize;
  final double? iconSize;
  final Duration animationDuration;
  final Curve animationCurve;
  
  const BottomNavigationModern({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedItemSize = 16.0,
    this.unselectedItemSize = 12.0,
    this.iconSize = 24.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final bgColor = backgroundColor ?? colorScheme.surface;
    final selectedColor = selectedItemColor ?? colorScheme.primary;
    final unselectedColor = unselectedItemColor ?? colorScheme.onSurfaceVariant;
    
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = index == currentIndex;
          
          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: animationDuration,
              curve: animationCurve,
              margin: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: isSelected ? 8 : 16,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: isSelected ? 12 : 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? selectedColor.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[index].icon,
                    color: isSelected ? selectedColor : unselectedColor,
                    size: iconSize,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    AnimatedDefaultTextStyle(
                      duration: animationDuration,
                      style: TextStyle(
                        color: selectedColor,
                        fontWeight: FontWeight.w600,
                        fontSize: selectedItemSize,
                      ),
                      child: Text(items[index].label),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class BottomNavigationItemData {
  final IconData icon;
  final String label;
  
  const BottomNavigationItemData({
    required this.icon,
    required this.label,
  });
}