import 'dart:html';

class Keyboard {
  static Map<int, bool> pressedKeys = {};

  static init() {
    window.onKeyDown.listen((event) => pressedKeys[event.keyCode] = true);
    window.onKeyUp.listen((event) => pressedKeys[event.keyCode] = false);
  }

  static bool isDown(int key) => pressedKeys[key] == true;
}