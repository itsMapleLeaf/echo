import 'dart:html';

import '../engine/actor.dart';
import '../engine/director.dart';

import '../props.dart';
import '../clock.dart';
import '../keyboard.dart';
import '../util.dart';

class InputDirector implements Director {
  final clock = new Clock();

  void direct(List<Actor> actors) {
    num dt = clock.step();

    for (final actor in actors) {
      if (actor.has([Velocity, PlayerInput])) {
        final targetVel
          = Keyboard.isDown(KeyCode.LEFT) ? -400
          : Keyboard.isDown(KeyCode.RIGHT) ? 400
          : 0;

        final vel = actor[Velocity];
        vel.x = lerp(vel.x, targetVel, dt * 12);
      }
    }
  }
}