import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  final double size;
  final double iconSize;

  const AuthLogo({
    super.key,
    this.size = 80,
    this.iconSize = 45,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.family_restroom,
        size: iconSize,
        color: Colors.white,
      ),
    );
  }
}