import 'dart:html';

import '../engine/actor.dart';
import '../engine/director.dart';

import '../props.dart';
import '../clock.dart';
import '../keyboard.dart';
import '../util.dart';

class InputDirector implements Director {
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