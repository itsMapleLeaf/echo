import 'dart:html';

import '../actor.dart';
import '../clock.dart';
import '../props.dart';
import '../keyboard.dart';
import '../util.dart';

class InputDirector {
  final clock = new Clock();

  bool isValid(Actor actor) => actor.has([Velocity, PlayerInput]);

  void direct(List<Actor> actors) {
    num dt = clock.step();

    for (final actor in actors) {
      var targetVel
        = Keyboard.isDown(KeyCode.LEFT) ? -400
        : Keyboard.isDown(KeyCode.RIGHT) ? 400
        : 0;

      Velocity vel = actor.get(Velocity);
      vel.x = lerp(vel.x, targetVel, dt * 12);
    }
  }
}