import '../engine/actor.dart';
import '../engine/director.dart';

import '../props.dart';
import '../graphics.dart';

class DrawingDirector implements Director {
  void direct(List<Actor> actors) {
    clear();

    for (final actor in actors) {
      if (actor.has([Position, Size, Appearance])) {
        final pos = actor[Position];
        final size = actor[Size];
        final color = actor[Appearance];

        canvas.context2D
          ..fillStyle = color.color
          ..fillRect(pos.x, pos.y, size.width, size.height);
      }
    }
  }
}