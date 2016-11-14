import 'dart:html';
import 'dart:math';

import 'color.dart';

final CanvasElement canvas = querySelector('canvas');

/// Utility class for working with fonts
/// For use with HTML5 canvas
class Font {
  final String family;
  final num size;

  Font(this.family, this.size);

  String toString() {
    return '${size}px $family';
  }

  static roboto(num size) => new Font('Roboto', size);
}

/// Draws a rectangle
drawRectangle(num x, num y, num width, num height, [Color color]) {
  canvas.context2D
    ..save()
    ..fillStyle = color
    ..fillRect(x, y, width, height)
    ..restore();
}

/// Draws an equilateral polygon
drawPolygon(num x, num y, num radius, int sides, Color color, [num rotation = 0]) {
  canvas.context2D
    ..save()
    ..beginPath();

  for (var i = 0; i < sides; i++) {
    final angle = (i / sides) * (PI * 2) + rotation;
    final ox = cos(angle) * radius;
    final oy = sin(angle) * radius;
    canvas.context2D.lineTo(x + ox, y + oy);
  }

  canvas.context2D
    ..fillStyle = color
    ..fill()
    ..restore();
}

/// Draw some text
drawText(String text, num x, num y, Color color, Font font, [String align = 'left']) {
  canvas.context2D
    ..save()
    ..fillStyle = color
    ..font = font.toString()
    ..textAlign = align
    ..fillText(text, x, y)
    ..restore();
}

/// Clear the canvas area to a given color
clear(Color color) {
  canvas.context2D
    ..save()
    ..fillStyle = color
    ..fillRect(0, 0, canvas.width, canvas.height)
    ..restore();
}

/// Reset the canvas transform state
reset() {
  canvas.context2D.resetTransform();
}

/// Perform drawing transforms within a transformation context
layer(drawOps()) {
  canvas.context2D.save();
  drawOps();
  canvas.context2D.restore();
}