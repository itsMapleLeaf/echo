import 'engine/stage.dart';

import 'actors/player.dart';

import 'directors/drawing.dart';
import 'directors/input.dart';
import 'directors/physics.dart';

class Game {
  final stage = new Stage([
    new InputDirector(),
    new PhysicsDirector(),
    new DrawingDirector(),
  ]);

  Game() {
    stage.add(new Player());
  }

  void step() {
    stage.step();
  }
}
