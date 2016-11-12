import 'dart:html';

import 'keyboard.dart';
import 'game.dart';

main() async {
  Keyboard.init();

  final game = new Game();
  while (true) {
    await window.animationFrame;
    game.step();
  }
}