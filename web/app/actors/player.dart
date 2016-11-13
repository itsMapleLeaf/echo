import '../engine/actor.dart';

import '../props.dart';

import '../color.dart';

class Player extends Actor {
  Player() : super([
    new Position(100, 100),
    new Size(50, 50),
    new Appearance(Color.gray),
    new Velocity(gravity: 800),
    new PlayerInput(),
  ]);
}