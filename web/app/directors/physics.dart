import '../engine/actor.dart';
import '../engine/director.dart';

import '../clock.dart';
import '../props.dart';

class PhysicsDirector implements Director {
  final clock = new Clock();

  void direct(List<Actor> actors) {
    num dt = clock.step();

    for (final actor in actors) {
      if (actor.has([Position, Velocity])) {
        final pos = actor[Position];
        final vel = actor[Velocity];

        vel.y += vel.gravity * dt;

        pos.x += vel.x * dt;
        pos.y += vel.y * dt;
      }
    }
  }
}