import 'dart:ui';
import 'package:flutter/material.dart';

class AuthGlassContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const AuthGlassContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.borderRadius = 45,
    this.padding = const EdgeInsets.all(25),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: maxWidth ?? 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Colors.transparent,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}