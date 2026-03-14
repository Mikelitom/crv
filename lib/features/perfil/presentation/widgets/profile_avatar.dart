import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC62828).withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 5,
                )
              ],
            ),
            child: const CircleAvatar(
              radius: 75,
              backgroundColor: Color(0xFFC62828),
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              ),
            ),
          ),
        );
      },
    );
  }
}