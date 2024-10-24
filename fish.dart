import 'package:flutter/material.dart';
import 'dart:math';

class Fish {
  Color color;
  double speed;
  Offset position;
  Offset direction;

  Fish({required this.color, required this.speed})
      : position =
            Offset(Random().nextDouble() * 300, Random().nextDouble() * 300),
        direction = Offset(
            Random().nextDouble() * 2 - 1, Random().nextDouble() * 2 - 1);

  Widget build() {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  void move() {
    position += direction * speed;

    // Bounce off the edges
    if (position.dx < 0 || position.dx > 280) {
      direction = Offset(-direction.dx, direction.dy);
    }
    if (position.dy < 0 || position.dy > 280) {
      direction = Offset(direction.dx, -direction.dy);
    }
  }
}
