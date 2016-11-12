import '../engine/actor.dart';
import '../engine/director.dart';

import '../props.dart';
import '../graphics.dart';

class DrawingDirector implements Director {
  bool isValid(Actor actor) => actor.has([Position, Size, Color]);

  void direct(List<Actor> actors) {
    clear();

    for (final actor in actors) {
      Position pos = actor.get(Position);
      Size size = actor.get(Size);
      Color color = actor.get(Color);

      canvas.context2D
        ..fillStyle = color.color
        ..fillRect(pos.x, pos.y, size.width, size.height);
    }
  }
}