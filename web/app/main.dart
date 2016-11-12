import 'dart:html';

import 'graphics.dart';
import 'keyboard.dart';
import 'game.dart';

main() async {
  Keyboard.init();

  final game = new Game();

  var time = await window.animationFrame;
  while (true) {
    final now = await window.animationFrame;
    final elapsed = (now - time) / 1000;
    time = now;

    game.update(elapsed);

    clear();
    game.draw();
  }
}