import 'dart:html';

import 'clock.dart';
import 'game.dart';

main() async {
  final game = new Game();
  final clock = new Clock();

  while (true) {
    await window.animationFrame;
    final dt = clock.step();
    game.update(dt);
    game.draw();
  }
}