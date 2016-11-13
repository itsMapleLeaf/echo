import '../engine/actor.dart';
import '../engine/director.dart';

import '../props.dart';
import '../graphics.dart';

import '../color.dart';

class DrawingDirector implements Director {
  void direct(List<Actor> actors) {
    clear(Color.white);

    for (final actor in actors) {
      if (actor.has([Position, Size, Appearance])) {
        final pos = actor[Position];
        final size = actor[Size];
        final appearance = actor[Appearance];
        drawRectangle(pos.x, pos.y, size.width, size.height, appearance.color);
      }
    }
  }
}