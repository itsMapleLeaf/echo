import 'dart:html';

import 'clock.dart';
import 'game.dart';

main() async {
  final game = new Game();
  final clock = new Clock();

  while (true) {
    await window.animationFrame;
    final dt = clock.step();

    if (dt > 0.5) continue;

    game.update(dt);
    game.draw();
  }
}