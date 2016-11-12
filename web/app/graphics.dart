import 'dart:html';

final CanvasElement canvas = querySelector('canvas');

clear() {
  canvas.context2D
    ..fillStyle = 'white'
    ..fillRect(0, 0, canvas.width, canvas.height);
}
