import 'dart:html';

export 'dart:html' show KeyCode;

enum KeyState {
  up,
  pressed,
  down,
  released,
}

class Keyboard {
  static Map<int, KeyState> keys = {};
  static bool initialized = false;

  static init() {
    window.onKeyDown.listen(keydown);
    window.onKeyUp.listen(keyup);
    initialized = true;
  }

  static keydown(KeyboardEvent event) async {
    keys[event.keyCode] = KeyState.pressed;
    await window.animationFrame;
    keys[event.keyCode] = KeyState.down;
  }

  static keyup(KeyboardEvent event) async {
    keys[event.keyCode] = KeyState.released;
    await window.animationFrame;
    keys[event.keyCode] = KeyState.up;
  }

  Keyboard() {
    if (!initialized) init();
  }

  bool isDown(int key)
    => keys[key] == KeyState.pressed
    || keys[key] == KeyState.down;

  bool wasPressed(int key) => keys[key] == KeyState.pressed;
  bool wasReleased(int key) => keys[key] == KeyState.released;
}