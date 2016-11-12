import 'directors/drawing.dart';
import 'directors/physics.dart';
import 'directors/input.dart';

import 'actor.dart';
import 'player.dart';

class Game {
  List<Actor> actors = [];

  final input = new InputDirector();
  final physics = new PhysicsDirector();
  final drawing = new DrawingDirector();

  Game() {
    actors.add(new Player());
  }

  void update(num dt) {
    input.direct(actors.where(input.isValid));
    physics.direct(actors.where(physics.isValid));
  }

  void draw() {
    drawing.direct(actors.where(drawing.isValid));
  }
}
