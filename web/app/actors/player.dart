import '../engine/actor.dart';

import '../props.dart';

class Player extends Actor {
  Player() : super([
    new Position(100, 100),
    new Size(50, 50),
    new Color('#333'),
    new Velocity(),
    new PlayerInput(),
  ]);
}